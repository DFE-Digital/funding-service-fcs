namespace Datafix.Tests.TestUtilities
{
    using System;

    public static class ResultPoller
    {
        public static bool CheckResultOfFunction(Func<bool> checkFn, int maxChecks, int intervalInSeconds)
        {
            bool success = false;
            int checks = 0;

            while (checks < maxChecks)
            {
                checks++;

                if (checkFn())
                {
                    success = true;
                    break;
                }

                if (checks < maxChecks)
                {
                    System.Threading.Tasks.Task.Delay(TimeSpan.FromSeconds(intervalInSeconds)).Wait();
                }
            }

            return success;
        }
    }
}