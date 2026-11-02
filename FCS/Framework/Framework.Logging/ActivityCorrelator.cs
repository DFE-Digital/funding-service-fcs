namespace SFA.FCT.Framework.Logging
{
    using System;
    using System.Diagnostics;
    using System.Diagnostics.Contracts;
    using Interfaces;

    public class ActivityCorrelator : IActivityCorrelator
    {
        private readonly TraceSource _traceSource;

        public ActivityCorrelator(TraceSource traceSource)
        {
            _traceSource = traceSource;
        }

        /// <summary>
        /// Gets the current activity id.
        /// </summary>
        public Guid ActivityId
        {
            get
            {
                return Trace.CorrelationManager.ActivityId;
            }
        }

        /// <summary>
        /// Starts the continuation of a logical activity on the current thread for an activity that has already been started elsewhere.
        /// </summary>
        /// <remarks>
        /// Nesting of activities is not permitted. So this method cannot be called again on the current thread unless <see cref="Finish"/> has been called first.
        /// </remarks>
        /// <param name="activityId">The activity id of the activity that is already in progress </param>
        public void Start(Guid activityId)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId == Guid.Empty, "An activity must not have been started");
            Trace.CorrelationManager.ActivityId = activityId;
            _traceSource.TraceEvent(TraceEventType.Transfer, 1, "Starting the continuation of activity {0:D}", Trace.CorrelationManager.ActivityId);
        }

        /// <summary>
        /// Starts a new logical activity on the current thread.
        /// </summary>
        /// <remarks>
        /// Nesting of activities is not permitted. So this method cannot be called again on the current thread unless <see cref="Finish"/> has been called first.
        /// </remarks>
        /// <returns>The new activity id.</returns>
        public Guid Start()
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId == Guid.Empty, "An activity must not have been started");
            Trace.CorrelationManager.ActivityId = Guid.NewGuid();
            _traceSource.TraceEvent(TraceEventType.Start, 1, "Starting a new activity {0:D}", Trace.CorrelationManager.ActivityId);
            return ActivityId;
        }

        /// <summary>
        /// Finishes a logical activity on the current thread.
        /// </summary>
        /// <remarks>
        /// <para>
        /// The work on the current thread for the current activity has been completed, but the activity as a whole may still be carrying on elsewhere.
        /// </para>
        /// <para>
        /// This method should only be called after <see cref="Start()"/> has been called on the current thread.
        /// </para>
        /// </remarks>
        public void Finish()
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            _traceSource.TraceEvent(TraceEventType.Start, 1, "Stopping activity {0:D}", Trace.CorrelationManager.ActivityId);
            Trace.CorrelationManager.ActivityId = Guid.Empty;
        }
    }
}
