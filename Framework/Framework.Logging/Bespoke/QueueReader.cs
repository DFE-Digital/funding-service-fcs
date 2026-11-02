namespace SFA.FCT.Framework.Logging.Bespoke
{
    using System;
    using System.Collections.Concurrent;
    using System.Timers;

    public class QueueReader
    {
        private readonly ConcurrentQueue<LogEntry> _logEntries;

        public QueueReader(ConcurrentQueue<LogEntry> logEntries)
        {
            _logEntries = logEntries;
        }

        public void StartDequeuingAndProcessing(Action<LogEntry> processMessage)
        {
            const int timerIntervalSeconds = 2;

            Timer timer = new Timer(interval: TimeSpan.FromSeconds(timerIntervalSeconds).TotalMilliseconds);
            timer.Elapsed += (sender, args) =>
            {
                timer.Enabled = false;
                DequeueAndProcessUntilEmpty(processMessage);
                timer.Enabled = true;
            };

            timer.Start();
        }

        private void DequeueAndProcessUntilEmpty(Action<LogEntry> processMessage)
        {
            while (_logEntries.TryPeek(out var logEntry))
            {
                processMessage(logEntry);

                _logEntries.TryDequeue(out logEntry);
            }
        }
    }
}
