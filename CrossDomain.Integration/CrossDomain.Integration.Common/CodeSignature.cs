namespace SFA.FCT.CrossDomain.Integration.Common
{
    /// <summary>
    /// Contains constants related to assembly signatures that are usefull somewhere else.
    /// </summary>
    public static class CodeSignature
    {
        /// <summary>
        /// Check http://blogs.msdn.com/b/miah/archive/2008/02/19/visual-studio-tip-get-public-key-token-for-a-stong-named-assembly.aspx
        /// on how to easily create an external tool in Visual Studio to give you the PublicKeys for any assemblies you want.
        /// </summary>
        public const string PublicKey = ", PublicKey=" +
                                        "0024000004800000940000000602000000240000525341310004000001000100a18e3faa70dd98" +
                                        "043289cb4a54b53474989f3e9d5159f7d8ec5149b0bf4d087203f81f8d4f200d19c31615744ba7" +
                                        "c452451722f4ffec26b7a664c775b8aa2f9964329aa43e8e17c0f313736c4bff95be6bb1f4b64e" +
                                        "d58d10c3cc4d7132134e2d6d18444f5aee24a3868b5626a5098308ec2cf853f5a49120cd0810c9" +
                                        "93269db2";
    }
}
