namespace SFA.FCT.Xrm.TestFramework.Utils
{
    using System;
    using Polly;

    public static class ActionRetrier
    {
        public static void RetryWhenExceptionThrown(Action action, int numRetries = 3)
        {
            RetryWhenExceptionMatchesPredicate(action, numRetries, ex => true);
        }

        public static void RetryWhenExceptionContainsText(Action action, string text, int numRetries = 3)
        {
            RetryWhenExceptionMatchesPredicate(action, numRetries, ex => ex.Message.Contains(text));
        }

        private static void RetryWhenExceptionMatchesPredicate(Action action, int numRetries, Func<Exception, bool> exceptionPredicate)
        {
            const int numSecondsToWaitBetweenRetries = 2;

            Policy.Handle(exceptionPredicate)
                .WaitAndRetry(numRetries, count => TimeSpan.FromSeconds(numSecondsToWaitBetweenRetries))
                .Execute(action);
        }
    }
}
