namespace SFA.FCT.Operations.Integrity.Exceptions
{
    using System;
    using System.Runtime.Serialization;

    /// <summary>
    /// Custom Exception for when an unknown integrity check is requested
    /// </summary>
    [Serializable]
    public class InvalidIntegrityCheckException : Exception
    {
        public InvalidIntegrityCheckException() : base()
        {

        }
        public InvalidIntegrityCheckException(string message) : base(message)
        {

        }
        public InvalidIntegrityCheckException(string message, Exception innerException) : base(message, innerException)
        {

        }
        public InvalidIntegrityCheckException(SerializationInfo info, StreamingContext context) : base(info, context)
        {

        }
    }
}
