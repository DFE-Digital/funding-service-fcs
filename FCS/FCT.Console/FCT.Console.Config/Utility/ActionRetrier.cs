namespace FCT.Console.Config.Utility
{
    using System;
    using Polly;

    public static class ActionRetrier
    {
        public static void RetryWhenExceptionThrown(Action action, int numRetries = 3)
        {
            RetryWhenExceptionMatchesPredicate<Exception>(action, ex => true, numRetries);
        }

        public static void RetryWhenExceptionContainsText(Action action, string text, int numRetries = 3)
        {
            RetryWhenExceptionMatchesPredicate<Exception>(action, ex => ex.Message.Contains(text), numRetries);
        }

        public static void RetryWhenExceptionMatchesPredicate<TException>(Action action, Func<TException, bool> exceptionPredicate, int numRetries = 3)
            where TException : Exception
        {
            const int numSecondsToWaitBetweenRetries = 2;

            Policy.Handle(exceptionPredicate)
                .WaitAndRetry(numRetries, count => TimeSpan.FromSeconds(numSecondsToWaitBetweenRetries))
                .Execute(action);
        }
    }
}