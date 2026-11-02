namespace SFA.FCT.ContractManagementService.NSB
{
    using System;

    public interface ISendOnlyBus
    {
        void Send<T>(string destination, T message);

        void Send<T>(string destination, Action<T> messageConstructor) where T : new();
    }
}