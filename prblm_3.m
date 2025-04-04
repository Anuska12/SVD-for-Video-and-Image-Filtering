figure;
semilogy(diag(S_boat), 'b'); hold on;
semilogy(diag(S_baboon), 'r');
legend('Boat', 'Baboon');
title('Singular values of Boat and Baboon images');
xlabel('Index'); ylabel('Singular Value (log scale)');
