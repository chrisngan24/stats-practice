
## Naive Bayesian Classifier

Say the event that item is a particular classification is given by the event A.
From our training data, we can determine a set of features that are unique to a class as a B.  

Conditional probability:
P(A|B) = [P(A AND B)]/P(B)

Bayes Theorem:

P(B|A) = P(A AND B)/P(A)
BUT
P(A AND B) = P(A|B)P(B)
Therefore:
P(B|A) = P(B)P(A|B) / P(A)


# Results

At a very basic level, it actually kind of works!

83% predictions were correct.  According to adults/adult.name, this was the expected results that matched the original research
Yay!
