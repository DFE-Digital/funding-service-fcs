using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Practices.EnterpriseLibrary.Common.Configuration;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using Microsoft.Practices.EnterpriseLibrary.Logging.Configuration;
using Microsoft.Practices.EnterpriseLibrary.Logging.TraceListeners;

namespace SFA.FCT.Framework.TestHelpers
{
    [ConfigurationElementType(typeof(CustomTraceListenerData))]
    public class TestListener : CustomTraceListener
    {
        public string Log { get { return LogBuilder.ToString(); } }

        private readonly static StringBuilder LogBuilder = new StringBuilder();

        public override void TraceData(TraceEventCache eventCache, string source, TraceEventType eventType, int id, object data)
        {
            var log = data as LogEntry;
            if (log != null && this.Formatter != null)
            {
                LogBuilder.Append(this.Formatter.Format(log));
            }
            else
            {
                LogBuilder.Append(data);
            }
        }

        public override void WriteLine(string message)
        {
            this.Write("\n" + message);
        }

        public override void Write(string message)
        {
            LogBuilder.Append(message);
        }

        public static void Reset()
        {
            LogBuilder.Clear();
        }
    }
}
