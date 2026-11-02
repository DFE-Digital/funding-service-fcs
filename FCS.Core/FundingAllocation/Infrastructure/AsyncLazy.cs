namespace FundingAllocation.Infrastructure
{
    using System;
    using System.Threading.Tasks;

    /// <summary>
    /// Please see this article - https://devblogs.microsoft.com/pfxteam/asynclazyt/
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class AsyncLazy<T> : Lazy<Task<T>>
    {
        public AsyncLazy(Func<Task<T>> taskFactory) :
            base(() => Task.Factory.StartNew(taskFactory).Unwrap())
        { }
    }
}
