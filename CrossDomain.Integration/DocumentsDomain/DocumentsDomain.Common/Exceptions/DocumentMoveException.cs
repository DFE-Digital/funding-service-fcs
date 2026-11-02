namespace SFA.FCT.DocumentsDomain.Common.Exceptions
{
    using System;

    public class DocumentMoveException : Exception
    {
        public DocumentMoveException(string message) : base(message) { }

        public DocumentMoveException(string message, Exception exception) : base(message, exception) {}
    }
}
