
a=0;b=1;
k=10;
f=@(x) x.^3;
alpha = 0; beta = 1;

exact = @(x) (sin(10.*x) ./ (10.*cos(10))) .* (1 + 6./10^4 - 3./10^2) - (6.*x/10^4) + (x.^3./10^2);

Ns = [10,20,30];

for i=1:3
    n = Ns(i);
    h=(b-a)/n;

    K = full(gallery('tridiag',n,-1,2,-1));
    K(n, n-1) = -1;
    K(n, n) = 1;
    K = (1/h) * K;

    M = full(gallery('tridiag',n,1,4,1));
    M(n, n) = 2;
    M = (h/6) * M;

    B = zeros(1,n);
    for m=1:n
        % B(m) = -integral(f, (m-1)*h, m*h);
        x1 = (m-1)*h;
        x2 = m*h;
        x3 = (m+1)*h;
        N1 = @(x) (x-x1)./h;
        N2 = @(x) (x3-x)./h;
        B(m) = -integral(@(x) f(x).*N1(x), (m-1)*h, m*h);
        % B(m) = B(m) - integral(@(x) f(x).*N1(x), (m-1)*h, m*h)
        if m<n
            B(m) = B(m)-integral(@(x) f(x).*N2(x), m*h, (m+1)*h);
        end
    end
    B(1) = B(1) - (1/h-k^2*h/6)*alpha;
    B(n) = B(n) + beta;

    u = [0, B / (K-k^2*M)];

    x = linspace(a, b, n+1);
    xe = linspace(a, b, 1000);
    figure;
    plot(x, u, xe, exact(xe));
    title("N=" + n);
    saveas(gcf, "q1aN="+n+".png")
end
