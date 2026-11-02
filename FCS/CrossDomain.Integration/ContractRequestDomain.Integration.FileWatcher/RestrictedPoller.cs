namespace SFA.FCT.ContractRequestDomain.Integration.FileWatcher
{
    using System;
    using System.Timers;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public static class RestrictedPoller
    {
        public static void StartPolling(Action poll, Func<ConnectionInfo, bool> canPoll, Func<ConnectionInfo> getConnection, ILogger logger, int timerIntervalSeconds = 30)
        {
            Timer timer = new Timer(interval: TimeSpan.FromSeconds(timerIntervalSeconds).TotalMilliseconds);
            timer.Elapsed += (sender, args) =>
            {
                ConnectionInfo connectionInfo = null;
                try
                {
                    connectionInfo = getConnection();

                    if (canPoll(connectionInfo))
                    {
                        timer.Enabled = false;
                        poll();
                        timer.Enabled = true;
                    }
                }
                catch (Exception e)
                {
                    logger.LogError(ContractRequestDomainEventLoggingId.FileWatcherFailed, $"Failed Polling - {e.Message} + {e.StackTrace}");
                    timer.Enabled = true;
                }
                finally
                {
                    try
                    {
                        connectionInfo?.Transaction.Commit();
                        connectionInfo?.Connection.Dispose();
                    }
                    catch (Exception e)
                    {
                        logger.LogError(ContractRequestDomainEventLoggingId.FileWatcherFailed, $"Failed Polling in Finally - {e.Message} + {e.StackTrace}");
                    }
                }
            };

            timer.Start();
        }
    }
}
