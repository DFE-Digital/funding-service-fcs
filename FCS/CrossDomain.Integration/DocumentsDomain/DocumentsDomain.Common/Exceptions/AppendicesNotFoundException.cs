namespace SFA.FCT.DocumentsDomain.Common.Exceptions
{
    using System;

    public class AppendicesNotFoundException : Exception
    {
        public AppendicesNotFoundException(string message) : base(message) { }

        public AppendicesNotFoundException(string message, Exception exception) : base(message, exception) {}
    }
}
