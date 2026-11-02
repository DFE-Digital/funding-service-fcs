namespace ContractManagementDomain.Termination.Infrastructure
{
    using System;

    public static class EitherExtensions
    {
        public static Either<L, RR> Map<L, R, RR>
            (this Either<L, R> @this, Func<R, RR> f)
            => @this.Match<Either<L, RR>>(
                l => new Either<L, RR>(l),
                r => new Either<L, RR>(f(r)));

        public static Either<LL, RR> Map<L, LL, R, RR>
            (this Either<L, R> @this, Func<L, LL> left, Func<R, RR> right)
            => @this.Match<Either<LL, RR>>(
                l => new Either<LL, RR>(left(l)),
                r => new Either<LL, RR>(right(r)));


        public static Either<L, RR> Bind<L, R, RR>
            (this Either<L, R> @this, Func<R, Either<L, RR>> f)
            => @this.Match(
                l => new Either<L, RR>(l),
                r => f(r));
    }
}