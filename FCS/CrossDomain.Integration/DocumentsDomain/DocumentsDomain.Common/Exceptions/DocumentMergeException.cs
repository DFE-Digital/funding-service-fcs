namespace SFA.FCT.DocumentsDomain.Common.Exceptions
{
    using System;

    public class DocumentMergeException : Exception
    {
        public DocumentMergeException(string message) : base(message) { }

        public DocumentMergeException(string message, Exception exception) : base(message, exception) {}
    }
}
