namespace SFA.FCT.CrossDomain.Integration.Common.Exceptions
{
    using System;

    public class FileNotFoundException : Exception
    {
        public FileNotFoundException(string message) : base(message) { }

        public FileNotFoundException(string message, Exception exception) : base(message, exception) {}
    }
}
