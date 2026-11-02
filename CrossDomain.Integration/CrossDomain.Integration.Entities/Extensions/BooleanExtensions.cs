namespace SFA.FCT.CrossDomain.Integration.Entities.Extensions
{
    using System;

    public static class BooleanExtensions
    {
        public static void ShouldBeFalse(this bool boolean, string message)
        {
            if (boolean)
            {
                throw new InvalidOperationException(message);
            }
        }
    }
}
