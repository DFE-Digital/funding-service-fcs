namespace SFA.FCT.Xrm.TestFramework.Utils
{
    using System;
    using Polly;

    public static class FunctionRetrier
    {
        public static T RetryWhenExceptionThrown<T>(Func<T> function, int numRetries = 3)
        {
            return RetryWhenExceptionMatchesPredicate(function, numRetries, ex => true);
        }

        private static T RetryWhenExceptionMatchesPredicate<T>(Func<T> function, int numRetries, Func<Exception, bool> exceptionPredicate)
        {
            const int numSecondsToWaitBetweenRetries = 2;

            return Policy.Handle(exceptionPredicate)
                .WaitAndRetry(numRetries, count => TimeSpan.FromSeconds(numSecondsToWaitBetweenRetries))
                .Execute(function);
        }
    }
}
