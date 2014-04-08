% EXPECTED_SEARCH_UTILITY_BOUND bounds l-step search expected utility.
%
% This file provides a bound on the l-step lookahead expected utility
% of an unlabeled point for the active search problem (corresponding
% to search_utility). This is accomplished via a function providing a
% bound on the maximum possible posterior probability after adding a
% number of positive observations. This function must satisfy the
% following API:
%
%   bound = probability_bound(problem, train_ind, observed_labels,
%                             test_ind, num_positives)
%
% which should return an upper bound for the maximum posterior
% probability after adding num_positives positive observations.
%
% function bound = expected_count_utility_bound(data, labels, train_ind, ...
%           test_ind, probability_bound, lookahead, num_positives)
%
% inputs:
%                data: an (n x d) matrix of input data
%              labels: an (n x 1) vector of labels (class 1 is
%                      tested against "any other class")
%           train_ind: an index into data/labels indicating the
%                      training points
%            test_ind: an index into data/labels indicating the
%                      test points
%   probability_bound: a function handle providing a probability bound
%           lookahead: the number of steps of lookahead to consider
%       num_positives: the number of additional positive
%                      observations to consider having added
%
% outputs:
%   bound: an upper bound for the (lookahead)-step expected count
%          utilities of the unlabeled points
%
% copyright (c) roman garnett, 2011--2012

function bound = expected_search_utility_bound(problem, train_ind, ...
          observed_labels, test_ind, probability_bound, lookahead, ...
          num_positives)

  current_probability_bound = probability_bound(problem, train_ind, ...
          observed_labels, test_ind, num_positives);

  if (lookahead == 1)
    % base case: we are simply left with the current max
    bound = current_probability_bound;

  else
    % otherwise, the bound may be written recursively as follows. either
    % we get a 1 with maximum probability equal to the current bound,
    % or we get a 0. in the former case, we get one more positive,
    % and in either case the lookahead decreases by 1.

    lower_bound = @(num_positives) expected_search_utility_bound(problem, ...
            train_ind, observed_labels, test_ind, probability_bound, ...
            lookahead - 1, num_positives);

    bound = ...
             current_probability_bound  * (1 + lower_bound(num_positives + 1)) + ...
        (1 - current_probability_bound) *      lower_bound(num_positives);
  end
end