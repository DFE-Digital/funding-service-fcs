namespace UnitTests.Common
{
    using System;
    using Polly;

    public static class FunctionRetrier
    {
        public static T RetryWhenExceptionThrown<T>(Func<T> function, int numRetries = 3)
        {
            return RetryWhenExceptionMatchesPredicate(function, numRetries, ex => true);
        }

        public static T RetryWhenExceptionContainsText<T>(Func<T> function, string text, int numRetries = 3)
        {
            return RetryWhenExceptionMatchesPredicate(function, numRetries, ex => ex.Message.Contains(text));
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
