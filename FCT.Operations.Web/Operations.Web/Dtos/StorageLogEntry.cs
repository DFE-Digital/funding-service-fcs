namespace Operations.Web.Dtos
{
    using System;

    public class StorageLogEntry
    {
        private DateTime? _dateOccurred = null;

        public StorageLogEntry(int eventId, string dateOccurredString, string message, int roleInstance)
        {
            EventId = eventId;
            DateOccurredString = dateOccurredString;
            Message = message;
            RoleInstance = roleInstance;
        }

        public int EventId { get; }

        public string DateOccurredString { get; }

        public string Message { get; }

        public int RoleInstance { get; }

        public DateTime GetDateTimeOccurred
        {
            get
            {
                if (!_dateOccurred.HasValue)
                {
                    _dateOccurred = DateTime.Parse(DateOccurredString);
                }

                return _dateOccurred.Value;
            }
        }

       // public IEventMetric EventMetric { get; set; }

        public string GetParameterValueFromMessage(string parameterName)
        {
            int indexOfParam = Message.IndexOf(parameterName, StringComparison.Ordinal);
            int startIndexOfValue = indexOfParam + parameterName.Length + 2;
            int endexOfValue = Message.IndexOf(" ", startIndexOfValue, StringComparison.Ordinal);
            if (endexOfValue == -1)
            {
                // we are at the end of the string
                return Message.Substring(startIndexOfValue).Trim('"');
            }

            return Message.Substring(startIndexOfValue, endexOfValue - startIndexOfValue - 1).Trim('"');
        }

        public string GetEmbeddedParameterValueFromMessage(string parameterName)
        {
            int indexOfParam = Message.IndexOf(parameterName, StringComparison.Ordinal);
            int startIndexOfValue = indexOfParam + parameterName.Length;
            int endexOfValue = Message.IndexOf(",", startIndexOfValue, StringComparison.Ordinal);
            if (endexOfValue == -1)
            {
                // we are at the end of the string
                return Message.Substring(startIndexOfValue).Trim('"');
            }

            return Message.Substring(startIndexOfValue, endexOfValue - startIndexOfValue).Trim('"');
        }
    }
}