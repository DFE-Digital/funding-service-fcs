namespace SFA.FCT.Framework.Logging.Interfaces
{
    using System;

    /// <summary>
    /// Supports the correlation of activities across thread and process boundaries.
    /// </summary>
    public interface IActivityCorrelator
    {
        /// <summary>
        /// Gets the current activity id.
        /// </summary>
        Guid ActivityId { get; }

        /// <summary>
        /// Starts the continuation of a logical activity on the current thread for an activity that has already been started elsewhere.
        /// </summary>
        /// <remarks>
        /// Nesting of activities is not permitted. So this method cannot be called again on the current thread unless <see cref="Finish"/> has been called first.
        /// </remarks>
        /// <param name="activityId">The activity id of the activity that is already in progress </param>
        void Start(Guid activityId);

        /// <summary>
        /// Starts a new logical activity on the current thread.
        /// </summary>
        /// <remarks>
        /// Nesting of activities is not permitted. So this method cannot be called again on the current thread unless <see cref="Finish"/> has been called first.
        /// </remarks>
        /// <returns>The new activity id.</returns>
        Guid Start();

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
        void Finish();
    }
}
