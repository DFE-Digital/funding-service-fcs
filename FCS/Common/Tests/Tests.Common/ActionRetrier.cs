namespace UnitTests.Common
{
    using System;
    using Polly;

    public static class ActionRetrier
    {
        public static void RetryWhenExceptionThrown(Action action, int numRetries = 3, int numSecondsToWaitBetweenRetries = 2)
        {
            RetryWhenExceptionMatchesPredicate<Exception>(action, ex => true, numSecondsToWaitBetweenRetries, numRetries);
        }

        public static void RetryWhenExceptionThrown<TException>(Action action, int numRetries = 3, int numSecondsToWaitBetweenRetries = 2)
            where TException : Exception
        {
            RetryWhenExceptionMatchesPredicate<TException>(action, ex => true, numSecondsToWaitBetweenRetries, numRetries);
        }

        public static void RetryWhenExceptionContainsText(Action action, string text, int numRetries = 3, int numSecondsToWaitBetweenRetries = 2)
        {
            RetryWhenExceptionMatchesPredicate<Exception>(action, ex => ex.Message.Contains(text), numSecondsToWaitBetweenRetries, numRetries);
        }

        public static void RetryWhenExceptionMatchesPredicate<TException>(Action action, Func<TException, bool> exceptionPredicate, int numRetries = 3, int numSecondsToWaitBetweenRetries = 2)
            where TException : Exception
        {
            Policy.Handle(exceptionPredicate)
                .WaitAndRetry(numRetries, count => TimeSpan.FromSeconds(numSecondsToWaitBetweenRetries))
                .Execute(action);
        }
    }
}
