namespace SFA.FCT.Operations.Integrity.Services
{
    using System;

    public interface IIntegrityCheckerRunner
    {
        void Run(string checkName, DateTime runStartDate);
    }
}
