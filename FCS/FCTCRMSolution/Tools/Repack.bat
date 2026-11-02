solutionpackager.exe /a:pack /f:..\SolutionFiles\unmanaged\CIBERSFAFCTSolution.zip /z:..\CIBERSFAFCTSolution.zip

copy ..\CIBERSFAFCTSolution.zip ..\..\FCTCrmConfig.ConfigPackage\FCTCrmConfig.ConfigPackage\bin\Debug\PkgFolder\Solutions

pause
