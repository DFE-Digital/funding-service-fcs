namespace Operations.Web.Dtos
{
    using System.Collections.Generic;
    using System.Linq;

    public class MethodMetrics
    {
        private IReadOnlyCollection<double> _eventTimes;
        public MethodMetrics(string methodName, string friendlyMethodName, double averageSeconds, double maxSeconds, string maxContextInfo, double minSeconds, string minContextInfo, int numEventsIncluded, IReadOnlyCollection<double> eventTimes)
        {
            MethodName = methodName;
            FriendlyMethodName = friendlyMethodName;
            AverageSeconds = averageSeconds;
            MaxSeconds = maxSeconds;
            MaxContextInfo = maxContextInfo;
            MinSeconds = minSeconds;
            MinContextInfo = minContextInfo;
            NumEventsIncluded = numEventsIncluded;
            EventTimes = eventTimes;
        }

        public string MethodName { get; }

        public string FriendlyMethodName { get; }

        public double AverageSeconds { get; }

        public double MaxSeconds { get; }

        public string MaxContextInfo { get; }

        public double MinSeconds { get; }

        public string MinContextInfo { get; }

        public int NumEventsIncluded { get; }

        public IReadOnlyCollection<double> EventTimes
        {
            get
            {
                return _eventTimes ?? Enumerable.Empty<double>().ToList();
            }
            set
            {
                _eventTimes = value;
            }
        }
    }
}