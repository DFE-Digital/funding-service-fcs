namespace SFA.FCT.CrossDomain.Integration.Common
{
    using System;

    public interface INeedScheduling<out T>
    {
        TimeSpan FirstTick { get; }

        TimeSpan Interval { get; }

        T Callback { get; }
    }
}
