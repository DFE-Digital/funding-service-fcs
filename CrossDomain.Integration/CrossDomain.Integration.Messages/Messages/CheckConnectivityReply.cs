namespace SFA.FCT.CrossDomain.Integration.Messages.Messages
{
    using System.Collections.Generic;

    public class CheckConnectivityReply
    {
        public CheckConnectivityReply(IReadOnlyCollection<Result> results)
        {
            Results = results;
        }

        public IReadOnlyCollection<Result> Results { get; }

        public override string ToString() =>
            $"Results: {string.Join(",", Results ?? new List<Result>())}";

        public class Result
        {
            public Result(string service, bool canConnect, string errorInfo, string supplementaryInfo)
            {
                Service = service;
                CanConnect = canConnect;
                ErrorInfo = errorInfo;
                SupplementaryInfo = supplementaryInfo;
            }

            public string Service { get; }
            public bool CanConnect { get; }
            public string ErrorInfo { get; }
            public string SupplementaryInfo { get; }

            public override string ToString() =>
                $" Service: {Service}, CanConnect: {CanConnect}, ErrorInfo: {ErrorInfo}, SupplementaryInfo: {SupplementaryInfo}";
        }
    }
}
