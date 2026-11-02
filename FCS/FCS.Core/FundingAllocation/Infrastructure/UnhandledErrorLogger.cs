namespace FundingAllocation.Infrastructure
{
    using System;
    using System.Threading.Tasks;
    using SFA.FCT.Framework.Logging.Interfaces;

    public static class UnhandledErrorLogger 
    {
        public static async Task<T> CatchLogRethrowAsync<T>(this Task<T> task, ILogger logger,
            Func<string> logMessageCreator)
        {
            try
            {
                return await task;
            }
            catch
            {
                logger.LogInformation(1, logMessageCreator());
                throw;
            }
        }
    }
}
