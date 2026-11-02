using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using Microsoft.Practices.EnterpriseLibrary.Logging.TraceListeners;

namespace SFA.FCT.Framework.TestHelpers
{

    public class FakeTraceListener : CustomTraceListener
    {
        private readonly static List<LogEntry> logEntries_ =
        new List<LogEntry>();
        private readonly static List<string> logMessages_ =
            new List<string>();


        public override void Write(string message)
        {
            logMessages_.Add(message);
        }

        public override void WriteLine(string message)
        {
            logMessages_.Add(message);
        }


        public override void TraceData(TraceEventCache eventCache, string source, TraceEventType eventType, int id, object data)
        {
            LogEntry le = data as LogEntry;
            if (le != null)
            {
                logEntries_.Add(le);
                if (Formatter != null)
                {
                    Write(Formatter.Format(le));
                    return;
                }
            }

            base.TraceData(eventCache, source, eventType, id, data);
        }
        public static IList<string> GetLogMessages()
        {
            return new ReadOnlyCollection<string>
                (logMessages_);
        }

        public static IList<LogEntry> GetLogEntries()
        {
            return new ReadOnlyCollection<LogEntry>
                (logEntries_);
        }

        public static void Reset()
        {
            logEntries_.Clear();
            logMessages_.Clear();
        }

    }
}
