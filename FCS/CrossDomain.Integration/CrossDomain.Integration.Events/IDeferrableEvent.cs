namespace SFA.FCT.CrossDomain.Integration.Events
{
    public interface IDeferrableEvent
    {
        int TimesMessageDeferred { get; set; }
    }
}