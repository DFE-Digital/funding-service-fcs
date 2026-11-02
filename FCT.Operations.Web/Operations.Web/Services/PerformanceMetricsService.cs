namespace Operations.Web.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dtos;
    using Repositories;
    using SFA.FCT.Framework.Logging.Bespoke;

    public class PerformanceMetricsService
    {
        //private readonly IAzureLoggerQueryRepository _azureLoggerQueryRepository;
        //private readonly IMetricsStorageService _metricsStorageService;

        private static readonly IList<MethodMetaData> MethodsMetaData = new List<MethodMetaData>
        {
            new MethodMetaData(
                methodName:
                "SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Handlers.AllocationDeliveryCommencedHandler",
                friendlyMethodName: "Pay Calc - Approval",
                getStartContextIdentifier: entry => entry.GetParameterValueFromMessage("Argument0"),
                getEndContextIdentifier: entry => entry.GetParameterValueFromMessage("Argument2"),
                startEventId: 900,
                endEventId: 901),

            new MethodMetaData(
                methodName:
                "SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Handlers.AllocationActualsVerifiedHandler",
                friendlyMethodName: "Pay Calc - Actuals for Allocation",
                getStartContextIdentifier: entry => entry.GetParameterValueFromMessage("Argument0"),
                getEndContextIdentifier: entry => entry.GetParameterValueFromMessage("Argument2"),
                startEventId: 926,
                endEventId: 901)
        };

        //public async Task<IReadOnlyCollection<MethodMetrics>> GetMethodMetrics(DateTime startDateTime,
        //    DateTime endDateTime)
        //{
        //    List<MethodMetrics> methodMetricsList = new List<MethodMetrics>();
        //    IReadOnlyCollection<StorageLogEntry>[] logEntries =
        //    await _azureLoggerQueryRepository.GetLogEntriesBetweenDates(startDateTime, endDateTime);

        //    IEnumerable<IGrouping<int, StorageLogEntry>> logEntriesGroupedByEventId =
        //        logEntries.SelectMany(col => col.ToList()).GroupBy(le => le.EventId).ToList();

        //    MethodsMetaData.ToList().ForEach(methodMetaData =>
        //    {
        //        IEnumerable<StorageLogEntry> startEventsForMethod =
        //            GetFlattenedListOfFilteredLogEntries(logEntriesGroupedByEventId,
        //                g => g.Key == methodMetaData.StartEventId);

        //        IEnumerable<StorageLogEntry> endEventsForMethod = GetFlattenedListOfFilteredLogEntries(logEntriesGroupedByEventId,
        //                g => g.Key == methodMetaData.EndEventId);

        //        IEnumerable<EventMetric> eventMetrics = startEventsForMethod.Select(startEvent => GetMetricForEvent(
        //            startEvent,
        //            methodMetaData.GetStartContextIdentifier,
        //            methodMetaData.GetEndContextIdentifier,
        //            endEventsForMethod)).ToList();

        //        IReadOnlyCollection<EventMetric> eventMetricsWithEndLogEntry = eventMetrics
        //            .Where(em => em.EndLogEntry != null)
        //            .ToList();

        //        IReadOnlyCollection<EventMetric> orderedByDurationDescendingEventMetrics = eventMetricsWithEndLogEntry
        //            .OrderByDescending(em => em.MethodDurationSeconds).ToList();

        //        if (orderedByDurationDescendingEventMetrics.Any())
        //        {
        //            var methodMetrics = CreateMethodMetrics(orderedByDurationDescendingEventMetrics, methodMetaData);

        //            methodMetricsList.Add(methodMetrics);
        //        }
        //    });
            
        //    // we don't want to return the list of Event Metrics to the client at this stage so remove them
        //    // they will come in handy later when we want to show a graph on the UI
        //    methodMetricsList.ForEach(mm => mm.EventTimes = Enumerable.Empty<double>().ToList());

        //    return methodMetricsList;
        //}

        private MethodMetrics CreateMethodMetrics(IReadOnlyCollection<EventMetric> orderedByDurationDescendingEventMetrics, MethodMetaData methodMetaData)
        {
            var longestEvent = orderedByDurationDescendingEventMetrics.First();
            var shortestEvent = orderedByDurationDescendingEventMetrics.Last();

            return new MethodMetrics(
                methodMetaData.MethodName,
                methodMetaData.FriendlyMethodName,
                orderedByDurationDescendingEventMetrics.Average(ee => ee.MethodDurationSeconds),
                longestEvent.MethodDurationSeconds,
                longestEvent.Context,
                shortestEvent.MethodDurationSeconds,
                shortestEvent.Context,
                orderedByDurationDescendingEventMetrics.Count,
                orderedByDurationDescendingEventMetrics.Select(e => e.MethodDurationSeconds).ToList());
        }

        private IEnumerable<StorageLogEntry> GetFlattenedListOfFilteredLogEntries(
            IEnumerable<IGrouping<int, StorageLogEntry>> logEntriesGroupedByEventId,
            Func<IGrouping<int, StorageLogEntry>, bool> filter)
        {
            return logEntriesGroupedByEventId.Where(filter).SelectMany(g => g.ToList()).ToList();
        }

        private EventMetric GetMetricForEvent(
            StorageLogEntry startEntry,
            Func<StorageLogEntry, string> getStartEntryContext,
            Func<StorageLogEntry, string> getEndEntryContext,
            IEnumerable<StorageLogEntry> endEntries)
        {
            // find first that matches the context but occurs after the start
            IOrderedEnumerable<StorageLogEntry> orderedEndEntries = endEntries.OrderBy(l => l.GetDateTimeOccurred);

            var startEntryContext = getStartEntryContext(startEntry);

            var matchingEndEntry =
                orderedEndEntries.FirstOrDefault(
                    oee =>
                        oee.GetDateTimeOccurred > startEntry.GetDateTimeOccurred &&
                        getEndEntryContext(oee) == startEntryContext &&
                        startEntry.RoleInstance == oee.RoleInstance);

            // if this end entry is used another metric then remove the end entry from the other, 
            // this allows us to cater for message replay
           // matchingEndEntry?.EventMetric?.RemoveEndEntry();

            if (matchingEndEntry != null)
            {
                EventMetric eventMetric = new EventMetric(
                    (matchingEndEntry.GetDateTimeOccurred - startEntry.GetDateTimeOccurred).TotalSeconds,
                    startEntryContext,
                    startEntry,
                    matchingEndEntry);

              //  matchingEndEntry.EventMetric = eventMetric;

                return eventMetric;
            }

            return EventMetric.GetEmptyEventMetric();
        }

        private class EventMetric
        {
            public EventMetric(double methodDurationSeconds, string context, StorageLogEntry startLogEntry, StorageLogEntry endLogEntry)
            {
                MethodDurationSeconds = methodDurationSeconds;
                Context = context;
                StartLogEntry = startLogEntry;
                EndLogEntry = endLogEntry;
            }

            private EventMetric()
            {
            }

            public static EventMetric GetEmptyEventMetric()
            {
                return new EventMetric();
            }

            public double MethodDurationSeconds { get; }

            public string Context { get; }

            public StorageLogEntry StartLogEntry { get; }

            public StorageLogEntry EndLogEntry { get; private set; }

            public void RemoveEndEntry()
            {
                EndLogEntry = null;
            }
        }
    }
}