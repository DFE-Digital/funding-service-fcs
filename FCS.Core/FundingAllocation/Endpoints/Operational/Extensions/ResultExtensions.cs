namespace FundingAllocation.Endpoints.Operational.Extensions
{
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;

    public static class ResultExtensions
    {
        public static CheckConnectivityReply.Result ToCheckConnectivityResult(this (bool canConnect, string errorInfo) result, string service, string suppInfo)
        {
            return new CheckConnectivityReply.Result(service, result.canConnect, result.errorInfo, suppInfo);
        }
    }
}
