namespace SFA.FCT.ContractRequestDomain.NSBFramework
{
    public interface IContentEnricher<T> where T : class
    {
        void Enrich(T message);
    }
}
