namespace SFA.FCT.ContractRequestDomain.NSBFramework
{
    public interface IOperator<T> where T : class
    {
        void Operate(T message);
    }
}
