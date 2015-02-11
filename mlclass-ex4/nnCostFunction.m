function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

h1 = sigmoid([ones(m, 1) X] * Theta1');
h2 = sigmoid([ones(m, 1) h1] * Theta2');

Jk = 0;
for k = 1:num_labels
    yk = (y==k);
    hk = h2(:,k);
    
    Jk = ((-yk)'*log(hk)-(1-yk)'*log(1-hk)) + Jk;
end

total1 = Theta1(:,(2:end));
total2 = Theta2(:,(2:end));
T1 = 0;
T2 = 0;

for j=1:size(Theta1,1)
    T1 = total1(j,:)*(total1(j,:))' + T1;
end

for j=1:size(Theta2,1)
    T2 = total2(j,:)*(total2(j,:))' + T2;
end 

J = Jk/m + lambda*(T1+T2)/(2*m);

newy = (1:num_labels)';
D_2 = zeros(size(Theta2,1),size(Theta2,2));
D_1 = zeros(size(Theta1,1),size(Theta1,2));

for i = 1:m
   a_1 = X(i,:)'; %400*1
   a_2 = sigmoid(Theta1*[1;a_1]); %25*1
   a_3 = sigmoid(Theta2*[1;a_2]); %10*1
  
   y_i = newy==y(i);
   delta_3 = a_3 - y_i;
   delta_2 = (Theta2'*delta_3).*[1;(sigmoidGradient(Theta1*[1;a_1]))];
   %Theta2'*delta_3 is 26*1
   %delta_2 is 26*1
   D_2 = D_2 + delta_3*([1;a_2]'); %10*26
   D_1 = D_1 + (delta_2(2:end))*([1;a_1]'); %25*401
end 

Reg_1 = [zeros(size(Theta1,1),1), Theta1(:,(2:end))];
Reg_2 = [zeros(size(Theta2,1),1), Theta2(:,(2:end))];
Theta1_grad = D_1/m + lambda*Reg_1/m;
Theta2_grad = D_2/m + lambda*Reg_2/m;
% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
