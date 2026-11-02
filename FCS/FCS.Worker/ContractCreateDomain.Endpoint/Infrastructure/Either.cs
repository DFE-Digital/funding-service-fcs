namespace ContractCreateDomain.Endpoint.Infrastructure
{
    using System;
    using System.Threading.Tasks;

    public class Either<TL, TR>
    {
        private readonly TL left;
        private readonly TR right;
        private readonly bool isLeft;

        public Either(TL left)
        {
            this.left = left;
            this.isLeft = true;
        }

        public Either(TR right)
        {
            this.right = right;
            this.isLeft = false;
        }

        public T Match<T>(Func<TL, T> leftFunc, Func<TR, T> rightFunc)
            => this.isLeft ? leftFunc(this.left) : rightFunc(this.right);


        public void Match(Action<TL> leftAction, Action<TR> rightAction)
        {
            if (this.isLeft)
            {
                leftAction(this.left);
            }
            else
            {
                rightAction(this.right);
            }
        }

        public void MatchLeft(Action<TL> leftAction)
        {
            if (this.isLeft)
            {
                leftAction(this.left);
            }
        }

        public Task MatchAsync(Func<TL, Task> leftFunc, Func<TR, Task> rightFunc)
        {
            if (this.isLeft)
            {
                return leftFunc(this.left);
            }

            return rightFunc(this.right);
        }

        public static implicit operator Either<TL, TR>(TL left) => new Either<TL, TR>(left);

        public static implicit operator Either<TL, TR>(TR right) => new Either<TL, TR>(right);
    }

    public static class EitherExtensions
    {
        public static Either<L, RR> Bind<L, R, RR>
            (this Either<L, R> @this, Func<R, Either<L, RR>> f)
            => @this.Match(
                l => new Either<L, RR>(l),
                r => f(r));
    }
}
