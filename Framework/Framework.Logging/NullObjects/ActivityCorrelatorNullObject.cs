namespace SFA.FCT.Framework.Logging.NullObjects
{
    using System;
    using Interfaces;

    public class ActivityCorrelatorNullObject : IActivityCorrelator
    {
        public Guid ActivityId
        {
            get { return Guid.NewGuid(); }
        }

        public void Start(Guid activityId)
        {
        }

        public Guid Start()
        {
            return Guid.NewGuid();
        }

        public void Finish()
        {
        }
    }
}
