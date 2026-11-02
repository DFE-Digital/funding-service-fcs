namespace SFA.FCT.Operations.Integrity.Utils
{
    using System;
    using Polly;

    public static class ActionRetrier
    {
        public static void RetryWhenExceptionThrown(Action action, int numRetries, int numSecondsToWaitBetweenRetries)
        {
            Policy.Handle<Exception>()
                .WaitAndRetry(numRetries, count => TimeSpan.FromSeconds(numSecondsToWaitBetweenRetries))
                .Execute(action);
        }
    }
}
