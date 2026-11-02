namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Exceptions
{
    using System;

    public class DuplicateKeyStorageException : Exception
    {
        public DuplicateKeyStorageException(Exception innerException)
            : base("Duplicate Key", innerException)
        {
        }
    }
}
