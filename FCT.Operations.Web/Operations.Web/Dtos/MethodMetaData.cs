namespace Operations.Web.Dtos
{
    using System;

    public class MethodMetaData
    {
        public MethodMetaData(
            string methodName,
            string friendlyMethodName,
            Func<StorageLogEntry, string> getStartContextIdentifier,
            Func<StorageLogEntry, string> getEndContextIdentifier, int startEventId, int endEventId)
        {
            MethodName = methodName;
            FriendlyMethodName = friendlyMethodName;
            GetStartContextIdentifier = getStartContextIdentifier;
            GetEndContextIdentifier = getEndContextIdentifier;
            StartEventId = startEventId;
            EndEventId = endEventId;
        }

        public string MethodName { get; }

        public string FriendlyMethodName { get; }

        public Func<StorageLogEntry, string> GetStartContextIdentifier { get; }

        public Func<StorageLogEntry, string> GetEndContextIdentifier { get; }

        public int StartEventId { get; }

        public int EndEventId { get; }
    }
}