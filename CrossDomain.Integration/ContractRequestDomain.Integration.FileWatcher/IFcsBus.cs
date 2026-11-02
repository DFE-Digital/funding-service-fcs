namespace SFA.FCT.ContractRequestDomain.Integration.FileWatcher
{
    using System;
    using System.Threading.Tasks;

    public interface IFcsBus
    {
        Task Publish<T>(Action<T> messageConstructor);
    }
}
