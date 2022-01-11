-- VECTRIC LUA SCRIPT
--[[
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented ; you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

-- Easy Flag Maker is written by JimAndi Gadgets of Houston Texas 2019
]]
-- ==================================================]]
-- Global Variables --
-- require("mobdebug").start()
require "strict"
local Flag         = {}
local DialogWindow = {}
Flag.HoistFlag = 30.0
Flag.Version = "(Ver: 4.10)"
Flag.HoistUnion = 0.5385
Flag.FlyFlag = 1.9
Flag.FlyUnion = 0.76
Flag.UnionStarCentersV = 0.054
Flag.UnionStarCentersH = 0.063
Flag.StarDia = 0.0616
Flag.Strip = 0.0769
-- ==================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ==================================================]]
DialogWindow.USAir = [[data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAA6EAAAH+BAMAAACfMhUSAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAPUExURcTExD1Gze4VH////wAAANmQwv0AAAAJcEhZcwAADsQAAA7EAZUrDhsAABhaSURBVHja7J1hcuMsDIb9wxfIjE/QyQG+mfoADnD/M31tN01tBwkJhC1h+LOdVXdjePArwMrr4bO3ptp/Qx+DTrS3TrS3TrS3TrS3TrQT7a0T7a0T7a0T7a0T7UR760R760R760R760SvRTT0Zr/5NdHHzWBzH72tWyfaiXainWgn2ol2op1ob51oJ9qJdqKdaCfaidYligPWEu1EO9HLEp1mbGDVRDvRTvSyRL1Oovvc0IkKET0t2onmE0V3M2qinSiV6PSplOjciXainei/ofucsQXKadEd8E6UQPS3Amn++WF/x/wrUDov+rmNdqIEotO6UHCO3SaKoimi9wapObbq+tXQvSe1cH50pbxJoq4T/bodfGToNin25Gig59GlPaL3kb8ymkDtUxdNEg2d6Op2mOMbiXBudHMDJ4jeh7E5osvg+EQn/Bm4PzU631hEXSf6GrsZ2xaeFt3ydqneD60RvQ+Y7lyBaOhEG1Ldr943l0i/JimiO5cg6jrRf0Q9OLKk6JwT/WbGi7pk7xtLpN+TFNEdZPcSJo8wS0fnY6IEoqETfT60muCRPTVK34/+9L6xRPozSWHdAYn+7PGhAhFKNAC3MB79V0bEiVKIuk705n9+ngLAjBD9/YMXff6fjKhL976pRPpvksK6A53rPmFNj1jpMzEa+NEbO3pDbSaeRJuyzngSZTprTJHhZEcnfvT1Izm6fvL31uYn0bEhY5tfolC/6d9k0lmQnSA6JLpvsD0n6XBNos/5DHffXvuVnSFckuhv78HuGyT626WxmKjOEnuU6Gs+N5RIX7IDZRIGUZXluzjRYWgukb4m6XBtos0k0vnaRP9630wiXU3SsZDopLLEnkx0bC2NFhE9u4g+Hk0TXc3nZhLpapICskshOq3/adAS7UTzia6/nzDriSaJrnvfSCJdT1JAdml51CPfXVh9e6FeFEnxnWgO0Zf+PdBBrRcNGSujeUl337LoArJLXOtO6MA+gdeLzjlr3c18biSRyhE9t3w3sV9NL/RbOWPYTtK47jRMdDufm0ikgkRPLt/NUd15IXTftOjGdadhorvet5BIhYl6dNyrRnOI7tJoC4l0P0mjukMnOk9YEf08YUX02dHvuuEpj+h+PjeQSCWJ+u8TAKTU/Ssa6kQ/v6PJNVs6jbaQSN+6FNMdMtHH9+Zwxh54efCUID86/WxUfQ7Rt97bT6SiRGes5OcZBYvo86MTGsWIvqVR+4n0fZLGdIdI9PksK+DRh3h0QqOdKJPoYz+wUBH9Y1vyLhd9/W08ihFdSN03LrqxTEIkWq2IvqjEHiE6X4PowCJqxNXcUxXKuuxGuxQuQzRchOjIIWrEp96TFcq47Ma75MWIqvGp99Q02iTRgUXUhk+9JyuUbdkFuhToRK24mntyGm2S6HgRogux++ZF9z2RwkS9EZ96T06jTRIdSERN+dR7ukJZPqyHJulbIo0SndYdV1NED0QR94lI960bakRmKclZQ2cRfTzqYNOb92bXBgcmSnO/ed0OZxXR00vsI5DuC7X71nypCLMUIPpSuLOK6Okl9g40cWqJ6L2U6NlF9IwSe8dQKLuyC0/S/SwFdy8eSGaHlFwXemAv7RENlyaKKJRZ2UW6tJulCdU9q+SaUZDtOApllej92kQRhbIqu9gk3c1SjKg36mq+tEc0lBP1hl3NUYkam0ujoyMSNexq3lwiZaTRRl3Nl8ZkF5ui4RKu5vfGdqSBrLksV/MbNxr40Rs/6sqOWIyn0feXKkBEaSXX4gXZGa7mjjmrx6bSaCC/SyLSdEYBovSTbdNpdPwoIKrVA9txR8G1k0ZjL7Jplij9EbHhNBo+rkQUHIexmTQ6fhQR1epTvyN6Tw+EaySNrjTXZRFV6oG9JxqSuusaSaN//QgtE/1YXGooxjbS6N/Uvc8fTRP9EyNAd8cm0ui6myGHqFqfeveWdVK6O7oWiK6lyDGJ6vapfyc6pHTXNZBGV5q7naIUojpL7MHdyzKkdDfYJzqub+GRvXtR7VMfIbqewIv1RBrvwUaGAn8/6jUV0aeIhs1dGKwn0ijRbf8cn+ikqYg+RfS+WwgaT6Qhpbm7CUpc6yr2qXfRSY0jDbaJ7jpHqxyL3iwqXc1dfEeO6u5oW3R3fQvNEw27eRwsJ9II0f26z33kq66Kkusk0XtMmqwm0pDS3P30bJLoMqR0Nxgmuj8/oX6T6agi+qISe+D56DKkkI52RfetVyGLqFdURB89K4x5FqwcCpaEeYHehlz5EvWWIBPVU0QPnX68+1OFVyxQ3qthwZfqz+1lDvGukF3NaxXRl5TYQ0Tnd2eYYPTFEvB1B8DRh0q0WhF9SYk9SHR5n9FG39C0gLfoAvSE6IEdKaJ/oGXyMtEbHoWI/o0DqLtGvKrmJaW5NIeqA4vo67iahyGpu95iGo31hu4LaNkDe8ZkylIiDSnN5Tg9mia6JJGO9tJotCsMN1bTrubLkNJdE4l0XlKay3FMNu1qHobkTeqtpdExCvqKruYA0mAsjca7MTKImvbABtgFY4k0pxeNEt2MBXV2q06j4ydRadp0NQdXQdFFsAWi9NVAm67m+615VLEMEE2u2KlEp81/i1TRaoh6yvGZj8ix/qVRiGlu3tsqV6MUqaMN50djdt3YEXf0tMXOwgg8+SITXX0/4YE+7jgrGlJ5dH+MG1Et9Yn0jx7ndBpYGU2g9qmLetqj4sigqCeafsxLJ/o7TnN8IxHOjb5bO7Me/i9GEmlIP+VlELXjr+tpz4pjT/+NpFEP3qKxHoD7UQ9q3wEl15yCbCrRd6TKE+nvDQlrblRl2iU6D0nd9RbSKKy58Q60q7oz8h682UIiDfBWGlutt0s08jLAvX6NBtIoornx68eIehM+9QyiewEzQBTTXB5Rb8an3n+SZfdNd736NIpoLnD5MFErPvUconsNU08U01wuUUIRvQ6fev9Jl93VIPyI2KhcdEd0esavHiRKKKLX4VPPI7odI+1EPbEvlHNdWhG9eIn9jR1FiM5DUne9atHFNRe4eIgorYhevMQ+w6eeSXQ771UTHck9IZ0Z6S25JlRgI1K1HadRs+h6akcuTnSjZZqJJjT3kkQBf9313PdqRTeludAZJp2oVldz/8lMpOtzGMVEscMi7HiEQVSpY7JPP49CdHdWStSnNBd8FmifKMeW4oXUUoPeOwD8un2iLuNFKbY9x3ADHzJRM67mlPdqGDIGXLivlqIQteVqTiJqxkaO3wMK0Wmdg/W7mpNmuBHdhV/oB6oMSXVtuZqTiBrR3Yzrp+XRv73RA6mirRjluJrTRMuE2WPIeNUxjehL/x4o8HrRcBMnakB3s15eTVzrWnI1J8qWAd3Nunjq7uXU8l2mBzZxUNTrLqK5FyaKyK72LUzmpfNUV0WBrhzR0armXpkoPi7BqOZic5FB1KPjXjVai6hi3UXFRYboPGFF9POEFdFnR7/rhqciogEfGa1I7/hMDMVE/fcJAFLq/hUNdaKf31FsaeRK5rpa3cUnIqYtZKKP783hjD3w8uApQX50+tmo+npElepuwVVTic5Yyc8zChbR50cnNEohmkikOnX3nrroj2Kiz2dZAY8+xKMTGpUgqnILU3LNGNHHfmChIvrHtuRdLvr6W8Sn3hUKmMJUGoaCVEEkWq2IvtynvpioOt1NaW42USOu5q5UwtTpbtkFd6LqdDepudlEjfjUJ4kmZVfXFqb0crOJqvGplyA6WtLcAqI2fOqdxBgFQ5qbmH8wUSuu5iJE1eguQVA6Udoo6UB6L599MFFvxKdehqgS3Q1DHaKmfOqdyGJDh+6S5l5iGRclqrOIHohKEVWgu/elFlGlRfTxqDtopHRsXNIzD8ijpxfR00vsnVR6Ol13SZqbTPiQ+83ZRfT0Ent32Oy3oLnwWvfkInpGib07cLT0ay6yezm15JpTkE27scKgfQsjdYVXIaped8VUxL4HNtWggjZip/lniF1ew67mNLsqmu3TUab0AlfXsKt53qCdY1k1k66N5HnXsKs51a8qY9QqvWUgdWm+jKh5V3NDuit5ZS27mpvR3VlyqrXsap6ru0cjlb0shqv5jRsN/OiNH/XnLECOTqJk6WjZ1dyI7s6y6Z3u9HjTGeURVai70pfUtAe2iS3MIiwbVyOqbgsjfj2XI6pMd+Uvp2mf+veeqtNdHtBZlqg9n/qtvHmFusu7ljl0omt9G2utRQ47oF98Jxp934Ye3WVq7iBKVK1PPfleWkZtusvU3GWUWhnp9qmnE/277XQcHXE1dxAjqrPEnv98dODqbl2kM1dzaVOMpLqqfeo5RNfDc3oq5S3Q5kWSqGqfes8ZQkW6y9Zc4gSjEX3pn4Yi+hKiq2XGybrLvIAwyBLV7FPvWXeFGt3lay5RMai7F48O7Jmu5jyiXN2ttYVhfvoydKLgfRHytvenaO6GP1EveKqrouS6kOio4egoQ3M7UXB5qUB3czSXuvBmEPVViuiLSuyziDJ1t8IWhrkqC0MFol5REX3BE+9lUKG7OZpLvgwyUT1F9MVEh5OP7LkH9EMVotWK6EtK7NlEw6BAd/M0lzyvqESrFdGXlNhnV2BzdVcSKfeAfpGpwN6XTUeK6B9ombxM9IZH+USXyBONg3U35CRRxqwiEq1WRF/uau6z1iThrCP7TM2lr88QokY8sH3WDXKW7uZqrsi3JIwQ5dkdRCwNaDfNkXYLQ+TXyZ+AEG3F1Ryw9QpnGOMwPytkGKJlE7Xjag6Z4ITjjXHuvI8KOeZZGNFWXM0Boq+Bo/nxjUfZir1uxzV/CaLteGBDboqH626+5jJcKK9MlKm7xd6eRC1wMf4SRH0zruag8I3uUCPIfM3lfHSUaGuu5uCwHqq7BZpbTHTa7ImRKloNUVcifQfqLnP9FXI/OK66qxOSSB1tOD+6Ut4iolzdzUfK/IDdrxcTXX0/4YE+7jgrGrLz6O5uHGUtxcU0d8nO4MDKaEK/naAqWkb0KN0t0lwJor+3wxzfSIRzo5sb2JXdLMfobpnmsqQBImrHX9cV3i2HHB0tLM194+8EiDbnag7rH3ML4w7X3E6Ueb/U191CzeXpwvVU910Bq+tuwWFRJ5olgZWPjkoOi/hCjxH1JnzqBYj+DVkN3eVq7lCHqDfjU+8ERLCq7pZqLvPjYKJWfOoliNbU3WLNlSJKKKLX4VPvRPYS1Y6OSh6KZu2XQKKEInodPvUyRGttYUo3LmJEDfnUZ+z4Fyw3yh7ZFx3QZ+2WIKJQBTsnOvGjUSd6PCpEtI7uCmiuEFFDLYNoGA7SXQnN5W5/L0n0ju9J5HRXQHPZB8nXJLoMh+hu6QF91jnyJYkCyKR1V0Rz2cfInWi9o6PCh6KdqMDzStGjo/LDoqznsZ1orSP78gP6TlTg9FxQd2U0l/80thOtpLtCmtuJFp+fO5ktDPOw6D5IiW4nWkl3hTS3ExV4DC2iu1Kam1HUtCEartMWlq0FyQUjauBBc+uQdPTYEK39ghNFLbCsZ1AuXs7iJjJf2D27KlHMKGrkuUkFGfvcePOdqIRTVKERJNFWjGIgOnaiIh63ZborqLk53r6XJYoqI1N3xww/ZJoOhE5UyHGxQHcFNTfLYfK6RJehiu5Kam6WweRliSbuPqYB75ipuQn+ORb5nWhKd5kOx7wJEIZO9Cjr4j/B48ioqObmGTV3oqK6K6q5nais7DJ19//2zi3JcRsGgP7ASVS+wfoAKhH3P1OqUsmMJZMiIPFlbuPXDrOlNhoipQEcRM1DoS5NmoFoIe8Gcz7b76MhWla7Pu/aidqH2gaIliXq8q6ZqGMQH0QLa/ch9qMjMX/x57DIvCZEixG9UPLWcs6FaAXt/nr3VYioX+QQLUrUfGQvxkOgYAcK0RraNXvXeFvseQBwce4pRMt410bUdWgB0TraNVIwJZ/LuVen70G0iHdtT9M8zoVoNe0+1GBUE9GfjYvjoBiiFYhavPt7+bWQcyF6TbvOd07WvCFfhZwrAaLVKqnBuwaiPuden0r8lxMt5d2QTXvHAf0d50K0jHcl/xtp5FyIur27XiPayrkQdf/ZkeaIagHn6h+I1i6l549KNUf0Z+NS27kQNVe2U++GjMbbOReiF0z4yhBdezoXomW8myHa0LkQLeLdzF8btnTugaj+tWGzYerrcrqYXP2/XIsd0esTcL89bE9D1DQeNDUO0+jcuxAgWqAV7nbW/ar6nD2I3uj6pvGvbye/Dqk7kw2iVbx7QrS1cyF61bvvbejkpENda+dC1O3dSCNISaf7/x89WzkXoiW6M0ryt3E+mqcKUIh6O6hGvLslibZ3LkRLbGG21DrqWvhR5vJD9L53t0SyN9+4QLSMdyVFtIdzIVrAu5LIde0CFKL3j44kvkof50L0Zild00R9GxdZIDqMd7doPe7kXIgW8G6UaC/nQrSAd6NEt15AIXp3C/OM0Xh2cy5EL3v3d0Z0bAnXr+NR9LpD9LZ3m6wE0ZZHR6VunCE6yhbm3jKPwlcdovVs2cO5EL3j3Ux2PRsfFkG0sne7FFGIVkywLkUUovWAdHIuRGtJs5dzIXqC1PaHQ6n7XFPUuOAQnS0gClECogRECYj2j2o3r3eIKnGzlYP0/3fQK6VwSyTtfREhWrrHVW+kEC3etEwhOluDqwDRyZrQCUS/PEVL94GD6HB9IiVAdKoU7XtzBNHyKdq3kkK0Qop2raQQLboXHUC7EK0g3a7ahWgN6fbULkRrSBeis0m3p3YhClHivYwaJpJCdFh6jhujONEXRMdKR71JNLoCRHtWzGC+1Y0SXZu4GKKOjac4iMa/KxAd6xZIrbe6EXaJFSDad5cSrhNdG90DQ9QUmniWbSeqrZ6GQ9RaRKOgzERfzR7LQNR5jqCXiL6vECA6ShGNWNNKdG33FhJEPc79QGUkqg3PfCHqcu7RuzaiTV/RhqjLuUcgJqKfU6IDRAfYuESBmE4BtemzNoi6iujRu5aTem37ZhlEfUX0ACRJ9DePoytU9C5EnUV0D+SVf4eh9cuCEHU7dwckSzRVaRWi4zj3HUjuXcB0EocWRGmPcYiTzcmuoUaEuH2Fmp016H5zaGiT76Oa6NEphp6uSj+j5t07LZ1xrxN9bBBtHCYcevrps3V3XYhedG5mALCYiNbxLkQvOfdNmevpCK7WXeohmga6GhvMP09JrXQ1/4oiuhsZsPo+ZPLAiEV0h0LP6mNuAIFCdIgiuquAH35+d6lnIYj2c+4exOFgSNTz02DK1hDOPaTWDukOqGGQD5PwRnDuMbPekIpuvmxnWuWIRH+RHoFC9EvK6Ef1++8hzOeMprV1IYXo7RujH6bRmVtPiH7b5qXdUhCFKERrHN6t7EchCtEK2l0bEZUNoiNU0q3LShCt591iRHmaNoh3SxGVDaJDeFdKZXuNCw7RZGh1orw5Nop3CxGVDaKDeHfrsQxEK3o3cZ2ePqL8lcQ4W5gtYWn1EJUFoqN4N1H/1sQHiXq8QXQY70qSvtgzXReIDuNdSWei3loDop22MCfYot7VVhsXiF707nZScdVWjXWB6EDe3U5SWUyvGskC0YG8GzPmevapaYU6RGmlEQ1DS4xIT42TBh1V/7V0v3F3BpTzJjmiuTZXdbtgQ9Td1ShH7LNTkbac2w5Rd+exkOvuqc7/HqKdvRtyjck+vPtqORAaot6Gj0dpRvrEnX2l+lQmiHq9KxnnxvKw3SQJiPq9K5bunpoiypSt8byrlu6eB+9qw9HBEPVuYULWuf9yD7FElgDR8bwb8s79SOVXM+dC1O/dkHfuRzq+Go5rh6jTu8aRTAekayvnQtS9hRFDEU3MbmpzeSHq9K6YnHtMybWVcyHq9m6wOfeA9NXKuRB1ezcYnfsxu6nVxYWo07shv3GJHPm9WjkXot4kVWMRPXpXA0QHRWp37s677S4tRG/sZDzeheg3nDa4vAvR4XemRqQQncm5PbwL0ZrO7eFdiFZ1bgfvQpQcJaij3OtClP0oREf1bvtLCtGq3pU/EJ3KuxIgOpd3e1xQiF4OHdG5EK3pXQndidJy4VaDhkfLdgu2Pgz0SinT27N6zyK63zTu7Vm/xQ1EG/aYq92bE6KdvKsLRKfyrmwQncu7/S4lRO8iHcu5EK3jXVkgOpd3N4jO5V1dIDrVFkYWiM5VSjeIzuVdXSA6lXdlgehc3t0gOtcWRheITuVdWSA6l3c3iM7lXV0gOtUWRhaIzuXdDaJzeVcXiM6FdIEoAVECohAlIEpAlIAoAVGIQhSiBEQJiBIQhSidNeaKHVFiloAoRAmIEhAlIEpAFKIERAmIEhAlIApRAqIERImCRP8BrUtmH2abMX8AAAAASUVORK5CYII=]]
-- =====================================================]]
function InquiryNumberBox(Header, Quest, Defaltxt)
--[[
-- nquiryNumberBox for user input with default number value
-- Caller: local x = InquiryNumberBox("Cabinet Maker", "Enter the cabinet height", 30.0)
-- Dialog Header: "Cabinet Maker"
-- User Question: "Enter the cabinet height"
-- Default value = 30.0
-- Returns = double
]]
  local myHtml = [[<!DOCTYPE html>
<html lang="en">
<title>Easy Flag Maker</title>
<style>
html {
	overflow: hidden;
}
.FormButton {
	font-weight: bold;
	width: 75px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
.h1-r {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	text-align: right;
}
.mypush {
	text-align: right;
	width:100%;
}
.myimg {
	text-align: center;
  white-space: nowrap;

}
body {
	overflow: hidden;
	background-color: #CCC;
}
table {
	width: 100%;
	border: 0;
}
</style>
</head>
<body>
<table>
  <tr>
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.USAir ..[[" width="260" height="150">
  </tr>
  <tr>
    <td class="h1-r"><label id="QuestionID" for="qInput">Your Message</label>
      <input type="text" id="qInput"  size="10" maxlength="10"  /></td>
</table>
<table>
  <tr>
    <td class="mypush">&nbsp;</td>
    <td><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel" /></td>
    <td><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK" /></td>
  </tr>
</table>
</body>
</html>]]
  local dialog = HTML_Dialog(true, myHtml, 300, 280, Header .. " " .. Flag.Version) ;
  dialog:AddLabelField("QuestionID", Quest) ;
  dialog:AddDoubleField("qInput", Defaltxt) ;
  if not dialog:ShowDialog() then
  -- DisplayMessageBox(tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight))
    Flag.HoistFlag = dialog:GetDoubleField("qInput")
    return false
  else
  -- DisplayMessageBox(tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight))
    Flag.HoistFlag = dialog:GetDoubleField("qInput")
    return true
  end

end
-- =====================================================]]
function USA_AirForceFlag(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Hoist")
  line:AppendPoint(Flag.Gpt1)
  line:LineTo(Flag.Gpt2)
  line:LineTo(Flag.Gpt3)
  line:LineTo(Flag.Gpt4)
  line:LineTo(Flag.Gpt1)
  layer:AddObject(CreateCadContour(line), true)
-- ======
  job:Refresh2DView()
  return true
end
-- ===================================================
function Stripe(job, p1, p2, p3, p4, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1) ;
  line:LineTo(p2) ;
  line:LineTo(p3) ;
  line:LineTo(p4) ;
  line:LineTo(p1) ;
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function Star(job, pt1)
  local p1 =  Polar2D(pt1,  18.0,  Flag.StarOutRadius) ;
  local p2 =  Polar2D(pt1,  54.0, Flag.StarInRadius) ;
  local p3 =  Polar2D(pt1,  90.0, Flag.StarOutRadius) ;
  local p4 =  Polar2D(pt1,  126.0, Flag.StarInRadius) ;
  local p5 =  Polar2D(pt1,  162.0, Flag.StarOutRadius) ;
  local p6 =  Polar2D(pt1,  198.0, Flag.StarInRadius) ;
  local p7 =  Polar2D(pt1,  234.0,Flag.StarOutRadius) ;
  local p8 =  Polar2D(pt1,  270.0, Flag.StarInRadius) ;
  local p9 =  Polar2D(pt1,  306.0, Flag.StarOutRadius) ;
  local p0 =  Polar2D(pt1,  342.0, Flag.StarInRadius) ;
  local line = Contour(0.0) ;
  local layer = job.LayerManager:GetLayerWithName("Stars") ;
  line:AppendPoint(p1) ;
  line:LineTo(p2) ;
  line:LineTo(p3) ;
  line:LineTo(p4) ;
  line:LineTo(p5) ;
  line:LineTo(p6) ;
  line:LineTo(p7) ;
  line:LineTo(p8) ;
  line:LineTo(p9) ;
  line:LineTo(p0) ;
  line:LineTo(p1) ;
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function DrawUnion(job)
  local pt1 =  Flag.Gpt4
  local pt2 =  Polar2D(pt1,  0.0, Flag.FlyUnion)
  local pt3 =  Polar2D(pt2,  270.0, Flag.HoistUnion)
  local pt4 =  Polar2D(pt1,  270.0, Flag.HoistUnion)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Fly")
  line:AppendPoint(pt1)
  line:LineTo(pt2)
  line:LineTo(pt3)
  line:LineTo(pt4)
  line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ===================================================
function DrawStars(job)
  local pt1 =  Flag.Gpt4
  local pt2 =  Flag.Gpt4
  for _ = 5, 1 , -1     do
    pt1 = Polar2D(pt1,  270.0, Flag.UnionStarCentersV)
    pt2 = Polar2D(pt1,      0.0, Flag.UnionStarCentersH)
    for _ = 6, 1 , -1     do
      Star(job, pt2)
      pt2 =  Polar2D(pt2,  0.0, Flag.UnionStarCentersH * 2.0)
    end
    pt1 =  Polar2D(pt1 ,  270.0, Flag.UnionStarCentersV )
  end
  pt1 = Flag.Gpt4
  pt1 = Polar2D(pt1,  270.0, Flag.UnionStarCentersV )
  for _ = 4, 1 , -1     do
    pt1 = Polar2D(pt1,  270.0, Flag.UnionStarCentersV  )
    pt2 = Polar2D(pt1,      0.0, Flag.UnionStarCentersH * 2.0)
    for _ = 5, 1 , -1     do
      Star(job, pt2)
      pt2 = Polar2D(pt2,  0.0, Flag.UnionStarCentersH * 2.0)
    end
    pt1 = Polar2D(pt1 ,  270.0, Flag.UnionStarCentersV)
  end
  job:Refresh2DView()
  return true
end
-- ===================================================
function DrawStripesX(job)
  local pt1 =  Flag.Gpt5
  local lay = "Stripe-Red"
  for _ = 7, 1 , -1     do
    local pt2 =  Polar2D(pt1,  0.0, Flag.FlyFlag - Flag.FlyUnion)
    local pt3 =  Polar2D(pt2,  270.0, Flag.Stripe)
    local pt4 =  Polar2D(pt1,  270.0, Flag.Stripe)
    Stripe(job, pt1, pt2, pt3, pt4,lay)
    if lay == "Stripe-Red" then
      lay = "Stripe-White"
    else
      lay = "Stripe-Red"
    end
    pt1 = pt4
  end
  pt1 =  Flag.Gpt6
  lay = "Stripe-White"
  for _ = 6, 1 , -1     do
    local pt2 =  Polar2D(pt1,  0.0, Flag.FlyFlag)
    local pt3 =  Polar2D(pt2,  270.0, Flag.Stripe)
    local pt4 =  Polar2D(pt1,  270.0, Flag.Stripe)
    Stripe(job, pt1, pt2, pt3, pt4, lay)
    pt1 = pt4
    if lay == "Stripe-Red" then
      lay = "Stripe-White"
    else
      lay = "Stripe-Red"
    end
  end
  job:Refresh2DView()
  return true
end

-- ===================================================
function DrawLogo(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("")
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.3103018987827546 * Flag.HoistFlag) + 1.0)
  line:ArcTo(Point2D((1.284180734823339 * Flag.HoistFlag) + 1.0 ,(0.2550181565625758 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.1997344143423969 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((1.394748219263696 * Flag.HoistFlag) + 1.0 ,(0.2550181565625758 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.3103018987827546 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.656823581569366 * Flag.HoistFlag) + 1.0 ,(0.6924 * Flag.HoistFlag) + 1.0)
  line:ArcTo(Point2D((1.656823581569366 * Flag.HoistFlag) + 1.0 ,(0.6924 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo((1.782402143697018 * Flag.HoistFlag) + 1.0 ,(0.9547316137502122  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.843733987910614 * Flag.HoistFlag) + 1.0 ,(0.8266103692142681  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.831693014995266 * Flag.HoistFlag) + 1.0 ,(0.817862090312707  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.659009262184336 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.656823581569418 * Flag.HoistFlag) + 1.0 ,(0.6923999999999999 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.656823581569366 * Flag.HoistFlag) + 1.0 ,(0.6924 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.477825744159424 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.477825744159424 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.41897280180579 * Flag.HoistFlag) + 1.0 ,(0.2291843358328294  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.45652270045518 * Flag.HoistFlag) + 1.0 ,(0.1144713692048107  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.563039737383077 * Flag.HoistFlag) + 1.0 ,(0.1918605264900446  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.569424034763024 * Flag.HoistFlag) + 1.0 ,(0.2051972219097862  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.477825744159424 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.477825744159424 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.381394955583902 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.381394955583902 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.772307652170651 * Flag.HoistFlag) + 1.0 ,(0.6290178633973333  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.854410353878447 * Flag.HoistFlag) + 1.0 ,(0.8043076109577858  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.351180562733786 * Flag.HoistFlag) + 1.0 ,(0.4386897663319345 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.381394955583902 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.022105372517486 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.022105372517486 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8965268103900171 * Flag.HoistFlag) + 1.0 ,(0.9547316137502122  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8351949661764212 * Flag.HoistFlag) + 1.0 ,(0.8266103692142681  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.019919691902579 * Flag.HoistFlag) + 1.0 ,(0.692400000000089  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.022105372517486 * Flag.HoistFlag) + 1.0 ,(0.6924000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.022105372517486 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.201103209927611 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.201103209927611 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.259956152281245 * Flag.HoistFlag) + 1.0 ,(0.2291843358328294  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.222406253631855 * Flag.HoistFlag) + 1.0 ,(0.1144713692048107  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.115889216703958 * Flag.HoistFlag) + 1.0 ,(0.1918605264900446  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.109504919324011 * Flag.HoistFlag) + 1.0 ,(0.2051972219097862  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.201103209927611 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.201103209927611 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.297533998503133 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.297533998503133 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9066213019163839 * Flag.HoistFlag) + 1.0 ,(0.6290178633973333  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8236142101213267 * Flag.HoistFlag) + 1.0 ,(0.8024183544873236  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8245186002085881 * Flag.HoistFlag) + 1.0 ,(0.8043076109577858  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.32774839135325 * Flag.HoistFlag) + 1.0 ,(0.4386897663319345 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.297533998503133 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.171418156562575 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.171418156562575  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.436959434638927 * Flag.HoistFlag) + 1.0 ,(0.1002578246026293  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.339464477043517 * Flag.HoistFlag) + 1.0 ,(0.0294235916434862  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.241969519448109 * Flag.HoistFlag) + 1.0 ,(0.1002578246026293 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.171418156562575 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.289764304064542 * Flag.HoistFlag) + 1.0 ,(0.3229638367399057 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.289764304064542 * Flag.HoistFlag) + 1.0 ,(0.3229638367399057  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9270110259548129 * Flag.HoistFlag) + 1.0 ,(0.5864240550251245  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.011664112258414 * Flag.HoistFlag) + 1.0 ,(0.4095851076545642  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.1306083608288 * Flag.HoistFlag) + 1.0 ,(0.3229404435871495 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.289764304064542 * Flag.HoistFlag) + 1.0 ,(0.3229638367399057 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.38918477048644 * Flag.HoistFlag) + 1.0 ,(0.322978449817563 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.38918477048644 * Flag.HoistFlag) + 1.0 ,(0.322978449817563  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.751917928132222 * Flag.HoistFlag) + 1.0 ,(0.5864240550251245  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.667264841828621 * Flag.HoistFlag) + 1.0 ,(0.4095851076545642  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.54854433907339 * Flag.HoistFlag) + 1.0 ,(0.323001200286491 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.38918477048644 * Flag.HoistFlag) + 1.0 ,(0.322978449817563 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()

  return true
end
-- ===================================================
function DrawStripes(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("")
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.834356400392603 * Flag.HoistFlag) + 1.0 ,(0.8461999999999998 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.834356400392603 * Flag.HoistFlag) + 1.0 ,(0.8461999999999998  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.838013391249596 * Flag.HoistFlag) + 1.0 ,(0.769300000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.854410353878447 * Flag.HoistFlag) + 1.0 ,(0.8043076109577858  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.806226511077266 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.764853031868567 * Flag.HoistFlag) + 1.0 ,(0.7692999999999999  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.843733987910614 * Flag.HoistFlag) + 1.0 ,(0.8266103692142681 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.834356400392603 * Flag.HoistFlag) + 1.0 ,(0.8461999999999998 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.801994754397191 * Flag.HoistFlag) + 1.0 ,(0.6923999999999997 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.801994754397191 * Flag.HoistFlag) + 1.0 ,(0.6923999999999997  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.753701909387158 * Flag.HoistFlag) + 1.0 ,(0.615499999999997  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.772307652170651 * Flag.HoistFlag) + 1.0 ,(0.6290178633973333 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.801994754397191 * Flag.HoistFlag) + 1.0 ,(0.6923999999999997 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.72902447667468 * Flag.HoistFlag) + 1.0 ,(0.5385999999999997 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.72902447667468 * Flag.HoistFlag) + 1.0 ,(0.5385999999999997  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.692116583639499 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.72902447667468 * Flag.HoistFlag) + 1.0 ,(0.5385999999999997 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.647858139702922 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.647858139702922 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.686069911889858 * Flag.HoistFlag) + 1.0 ,(0.5386  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.579912413333534 * Flag.HoistFlag) + 1.0 ,(0.4615000000000006  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.5417390936346 * Flag.HoistFlag) + 1.0 ,(0.4615000000000006 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.647858139702922 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(1.0 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(1.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(1.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.9231  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.797544247676556 * Flag.HoistFlag) + 1.0 ,(0.9230999999999994  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.782402143697018 * Flag.HoistFlag) + 1.0 ,(0.9547316137502122  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.767260039717473 * Flag.HoistFlag) + 1.0 ,(0.9231000000000005  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9116689143695643 * Flag.HoistFlag) + 1.0 ,(0.9231000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8965268103900171 * Flag.HoistFlag) + 1.0 ,(0.9547316137502122  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8813847064104682 * Flag.HoistFlag) + 1.0 ,(0.9231  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.9231 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(1.0 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.190233752062472 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.190233752062472 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.488695202024561 * Flag.HoistFlag) + 1.0 ,(0.5386  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.382576155956235 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.2963527981308 * Flag.HoistFlag) + 1.0 ,(0.4615000000000005 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.190233752062472 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8762801719802885 * Flag.HoistFlag) + 1.0 ,(0.6924000000000017  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9066213019163839 * Flag.HoistFlag) + 1.0 ,(0.6290178633973333  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9252270446998737 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.9928590421971858 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9928590421971858 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.031070814384109 * Flag.HoistFlag) + 1.0 ,(0.5385999999999997  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.137189860452254 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.099016540753501 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9928590421971858 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.949904477412351 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9868123704473551 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.534184833885816 * Flag.HoistFlag) + 1.0 ,(0.2307999999999995 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.534184833885816 * Flag.HoistFlag) + 1.0 ,(0.2307999999999995  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.510791555030611 * Flag.HoistFlag) + 1.0 ,(0.1538999999999997  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.563039737383077 * Flag.HoistFlag) + 1.0 ,(0.1918605264900446  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.569424034763024 * Flag.HoistFlag) + 1.0 ,(0.2051972219097862 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.534184833885816 * Flag.HoistFlag) + 1.0 ,(0.2307999999999995 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.259956152281245 * Flag.HoistFlag) + 1.0 ,(0.2291843358328294 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.259956152281245 * Flag.HoistFlag) + 1.0 ,(0.2291843358328294  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.257722129190284 * Flag.HoistFlag) + 1.0 ,(0.230800000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.289759576035693 * Flag.HoistFlag) + 1.0 ,(0.230794015592243  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.293577841127102 * Flag.HoistFlag) + 1.0 ,(0.2241784535311492  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.298243108707986 * Flag.HoistFlag) + 1.0 ,(0.2181811605085455  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.303673998609975 * Flag.HoistFlag) + 1.0 ,(0.2128834465630245  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.309789130664699 * Flag.HoistFlag) + 1.0 ,(0.2083666217331786  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.316507124703786 * Flag.HoistFlag) + 1.0 ,(0.2047119960576003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.323746600558865 * Flag.HoistFlag) + 1.0 ,(0.2020008795748823  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.331426178061566 * Flag.HoistFlag) + 1.0 ,(0.200314582323617  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.1997344143423969  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.347502776025471 * Flag.HoistFlag) + 1.0 ,(0.2003145823236173  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.355182353528173 * Flag.HoistFlag) + 1.0 ,(0.2020008795748832  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.362421829383254 * Flag.HoistFlag) + 1.0 ,(0.2047119960576021  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.369139823422341 * Flag.HoistFlag) + 1.0 ,(0.2083666217331813  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.375254955477065 * Flag.HoistFlag) + 1.0 ,(0.2128834465630282  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.380685845379055 * Flag.HoistFlag) + 1.0 ,(0.2181811605085502  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.385351112959939 * Flag.HoistFlag) + 1.0 ,(0.2241784535311546  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.389169378051347 * Flag.HoistFlag) + 1.0 ,(0.2307940155922488  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.421206824896839 * Flag.HoistFlag) + 1.0 ,(0.2308000000000008  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.41897280180579 * Flag.HoistFlag) + 1.0 ,(0.2291843358328294  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.44361621626456 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.363465656973078 * Flag.HoistFlag) + 1.0 ,(0.1539000000000004  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.171418156562575  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.315463297113959 * Flag.HoistFlag) + 1.0 ,(0.153900000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.235312737822475 * Flag.HoistFlag) + 1.0 ,(0.1539000000000004 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.259956152281245 * Flag.HoistFlag) + 1.0 ,(0.2291843358328294 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.144744120201222 * Flag.HoistFlag) + 1.0 ,(0.2307999999999995  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.109504919324011 * Flag.HoistFlag) + 1.0 ,(0.2051972219097862  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.115889216703958 * Flag.HoistFlag) + 1.0 ,(0.1918605264900446  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.168137399056425 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.27398116874066 * Flag.HoistFlag) + 1.0 ,(0.0769999999999982  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.339464477043517 * Flag.HoistFlag) + 1.0 ,(0.0294235916434855  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.404947785346376 * Flag.HoistFlag) + 1.0 ,(0.0770000000000011  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.0001000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.0001000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.045963222162171 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.1306083608288 * Flag.HoistFlag) + 1.0 ,(0.3229404435871495  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.289764304064542 * Flag.HoistFlag) + 1.0 ,(0.3229638367399057  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.204898663178675 * Flag.HoistFlag) + 1.0 ,(0.3845999999999998  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.243033630136674 * Flag.HoistFlag) + 1.0 ,(0.3845999999999996  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.297533998503133 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.310304173943993 * Flag.HoistFlag) + 1.0 ,(0.3845999999999994  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.368624780143042 * Flag.HoistFlag) + 1.0 ,(0.3846000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.381394955583902 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.435895323950362 * Flag.HoistFlag) + 1.0 ,(0.3845999999999994  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.474030290908362 * Flag.HoistFlag) + 1.0 ,(0.3845999999999994  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.38918477048644 * Flag.HoistFlag) + 1.0 ,(0.3229784498175632  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.54854433907339 * Flag.HoistFlag) + 1.0 ,(0.323001200286491  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.548696910628449 * Flag.HoistFlag) + 1.0 ,(0.3230018953250635  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.548194786879353 * Flag.HoistFlag) + 1.0 ,(0.32285702876759  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.632962477709387 * Flag.HoistFlag) + 1.0 ,(0.3845999999999994  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.3077000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.355974048345025 * Flag.HoistFlag) + 1.0 ,(0.3077445617544825  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.351995768300622 * Flag.HoistFlag) + 1.0 ,(0.3088526571108061  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.347909589755614 * Flag.HoistFlag) + 1.0 ,(0.3096530182203129  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.343728247679935 * Flag.HoistFlag) + 1.0 ,(0.3101384853539724  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.3103018987827546  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.335149835947777 * Flag.HoistFlag) + 1.0 ,(0.3101356578482816  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.330925877439079 * Flag.HoistFlag) + 1.0 ,(0.3096436681408907  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.326804842503671 * Flag.HoistFlag) + 1.0 ,(0.3088360293046244  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.322798972127803 * Flag.HoistFlag) + 1.0 ,(0.3077228409835251  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.3077000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.9484810670855984 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9484810670855984 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.730447887001434 * Flag.HoistFlag) + 1.0 ,(0.8461999999999998  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.693635734285402 * Flag.HoistFlag) + 1.0 ,(0.7692999999999994  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9852932198016325 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9484810670855984 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8445725536944323 * Flag.HoistFlag) + 1.0 ,(0.8461999999999992  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8351949661764212 * Flag.HoistFlag) + 1.0 ,(0.8266103692142681  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9140759222184739 * Flag.HoistFlag) + 1.0 ,(0.7692999999999959  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8727024430097631 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8245186002085881 * Flag.HoistFlag) + 1.0 ,(0.8043076109577858  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8236142101213281 * Flag.HoistFlag) + 1.0 ,(0.802418354487322  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.839468019264266 * Flag.HoistFlag) + 1.0 ,(0.7692999999999963  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.9785462126940035 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9785462126940035 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.700382741393033 * Flag.HoistFlag) + 1.0 ,(0.6923999999999999  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.594538971708796 * Flag.HoistFlag) + 1.0 ,(0.6155000000000004  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.08438998237824 * Flag.HoistFlag) + 1.0 ,(0.6154999999999999 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9785462126940035 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.838013391249593 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.838013391249593 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.801994754397191 * Flag.HoistFlag) + 1.0 ,(0.692399999999999 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.838013391249593 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.764853031868567 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.764853031868567 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.806226511077269 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.700382741393029 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.659009262184336 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.764853031868567 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.753701909387162 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.753701909387162 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.729024476674679 * Flag.HoistFlag) + 1.0 ,(0.5386000000000004  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.751917928132222 * Flag.HoistFlag) + 1.0 ,(0.5864240550251245  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.68606991188985 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.647858139702928 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.753701909387162 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.692116583639499 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.692116583639499 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.632962477709389 * Flag.HoistFlag) + 1.0 ,(0.3845999999999987  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.667264841828621 * Flag.HoistFlag) + 1.0 ,(0.4095851076545642 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.692116583639499 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.541739093634598 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.541739093634598 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.579912413333535 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.474030290908362 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.435895323950364 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.541739093634598 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.9852932198014487 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9852932198014487 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.6936357342854 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.656823581569416 * Flag.HoistFlag) + 1.0 ,(0.6923999999999999  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.022105372517486 * Flag.HoistFlag) + 1.0 ,(0.6923999999999997 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9852932198014487 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.9231 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.9231  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8813847064102834 * Flag.HoistFlag) + 1.0 ,(0.9231  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8445725536942498 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.9231 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.084389982378054 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.084389982378054 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.594538971708796 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.488695202024562 * Flag.HoistFlag) + 1.0 ,(0.5386  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.19023375206229 * Flag.HoistFlag) + 1.0 ,(0.5386 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.084389982378054 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.872702443009589 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.872702443009589 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9140759222182827 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.019919691902515 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9785462126938206 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.872702443009589 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.296352798130616 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.296352798130616 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.382576155956237 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.351180562733786 * Flag.HoistFlag) + 1.0 ,(0.4386897663319345  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.368624780143041 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.310304173943811 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.327748391353067 * Flag.HoistFlag) + 1.0 ,(0.4386897663319345 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.296352798130616 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.099016540753314 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.099016540753314 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.137189860452254 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.243033630136488 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.204898663178488 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.099016540753314 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9252270446996943 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.031070814383926 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9928590421969968 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9270110259546299 * Flag.HoistFlag) + 1.0 ,(0.5864240550251245  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9499044774121842 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9868123704473551 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.011664112258231 * Flag.HoistFlag) + 1.0 ,(0.4095851076545642  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.045966476377473 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.363465656973077 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.363465656973077 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.443616216264561 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.45652270045518 * Flag.HoistFlag) + 1.0 ,(0.1144713692048107  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.51079155503061 * Flag.HoistFlag) + 1.0 ,(0.1538999999999995  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.40494778534638 * Flag.HoistFlag) + 1.0 ,(0.077000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.436959434638927 * Flag.HoistFlag) + 1.0 ,(0.1002578246026293 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.363465656973077 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.3077000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.3077000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.322913598076201 * Flag.HoistFlag) + 1.0 ,(0.307744481707503  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.318733548120583 * Flag.HoistFlag) + 1.0 ,(0.3062571638436854  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.31472418508491 * Flag.HoistFlag) + 1.0 ,(0.3044550190142494  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.310899168340366 * Flag.HoistFlag) + 1.0 ,(0.3023538507844633  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.307272157258138 * Flag.HoistFlag) + 1.0 ,(0.2999694627195956  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.30385681120941 * Flag.HoistFlag) + 1.0 ,(0.2973176583849146  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.300666789565367 * Flag.HoistFlag) + 1.0 ,(0.2944142413456888  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.297715751697196 * Flag.HoistFlag) + 1.0 ,(0.2912750151671867  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.29501735697608 * Flag.HoistFlag) + 1.0 ,(0.2879157834146766  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.292585264773206 * Flag.HoistFlag) + 1.0 ,(0.2843523496534268  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.290433134459759 * Flag.HoistFlag) + 1.0 ,(0.280600517448706  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.288574625406923 * Flag.HoistFlag) + 1.0 ,(0.2766760903657823  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.287023396985885 * Flag.HoistFlag) + 1.0 ,(0.2725948719699243  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.285793108567828 * Flag.HoistFlag) + 1.0 ,(0.2683726658264004  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.28489741952394 * Flag.HoistFlag) + 1.0 ,(0.2640252755004789  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.284349989225404 * Flag.HoistFlag) + 1.0 ,(0.2595685045574284  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.284164477043407 * Flag.HoistFlag) + 1.0 ,(0.2550181565625171  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.284533542987333 * Flag.HoistFlag) + 1.0 ,(0.2485947923018626  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.285613413568623 * Flag.HoistFlag) + 1.0 ,(0.242388583274863  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.287363097911538 * Flag.HoistFlag) + 1.0 ,(0.2364410934646564  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.289741605140342 * Flag.HoistFlag) + 1.0 ,(0.2307938868543813  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.257722129190099 * Flag.HoistFlag) + 1.0 ,(0.2308000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.201103209927428 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.144744120201038 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.3077000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.168137399056242 * Flag.HoistFlag) + 1.0 ,(0.1538999999999995  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.222406253631672 * Flag.HoistFlag) + 1.0 ,(0.1144713692048107  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.235312737822289 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.315463297113777 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.241969519447926 * Flag.HoistFlag) + 1.0 ,(0.1002578246026293  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.273981168740472 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.355841812466592 * Flag.HoistFlag) + 1.0 ,(0.3077732437070635 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.355841812466592 * Flag.HoistFlag) + 1.0 ,(0.3077732437070635  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.3077000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.534184833885811 * Flag.HoistFlag) + 1.0 ,(0.2308000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.477825744159424 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.421206824896753 * Flag.HoistFlag) + 1.0 ,(0.2308000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.389187348941953 * Flag.HoistFlag) + 1.0 ,(0.2307938868497543  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.391565856172656 * Flag.HoistFlag) + 1.0 ,(0.2364410934592643  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.393315540516992 * Flag.HoistFlag) + 1.0 ,(0.2423885832703107  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.394395411099171 * Flag.HoistFlag) + 1.0 ,(0.2485947922992696  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.394764477043406 * Flag.HoistFlag) + 1.0 ,(0.2550181565625171  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.394576859570537 * Flag.HoistFlag) + 1.0 ,(0.2595983680874002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.394023494035761 * Flag.HoistFlag) + 1.0 ,(0.2640804765670942  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.393118610764824 * Flag.HoistFlag) + 1.0 ,(0.2684488464090439  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.391876440083473 * Flag.HoistFlag) + 1.0 ,(0.2726878420206942  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.390311212317453 * Flag.HoistFlag) + 1.0 ,(0.2767818278094899  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.388437157792511 * Flag.HoistFlag) + 1.0 ,(0.2807151681828759  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.386268506834394 * Flag.HoistFlag) + 1.0 ,(0.2844722275482969  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.383819489768848 * Flag.HoistFlag) + 1.0 ,(0.2880373703131979  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.381104336921619 * Flag.HoistFlag) + 1.0 ,(0.2913949608850236  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.378137278618453 * Flag.HoistFlag) + 1.0 ,(0.2945293636712189  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.374932545185098 * Flag.HoistFlag) + 1.0 ,(0.2974249430792286  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.371504366947299 * Flag.HoistFlag) + 1.0 ,(0.3000660635164977  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.367866974230802 * Flag.HoistFlag) + 1.0 ,(0.3024370893904709  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.364034597361355 * Flag.HoistFlag) + 1.0 ,(0.304522385108593  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.360021466664702 * Flag.HoistFlag) + 1.0 ,(0.3063063150783089 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.355841812466592 * Flag.HoistFlag) + 1.0 ,(0.3077732437070635 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.839468019264266 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8762801719802865 * Flag.HoistFlag) + 1.0 ,(0.6924000000000019  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.9116689143693836 * Flag.HoistFlag) + 1.0 ,(0.9231000000000003 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9116689143693836 * Flag.HoistFlag) + 1.0 ,(0.9231000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.767260039717482 * Flag.HoistFlag) + 1.0 ,(0.9231000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.730447887001443 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.948481067085417 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9116689143693836 * Flag.HoistFlag) + 1.0 ,(0.9231000000000003 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.797544247676569 * Flag.HoistFlag) + 1.0 ,(0.9231 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.797544247676569 * Flag.HoistFlag) + 1.0 ,(0.9231  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.9231  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.834356400392603 * Flag.HoistFlag) + 1.0 ,(0.8461999999999998 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.797544247676569 * Flag.HoistFlag) + 1.0 ,(0.9231 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()


  return true
end

-- ===================================================
function main()
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions \n"
    )
    return false ;
  end
  local Loops = true
  while Loops do
    Flag.Inquiry = InquiryNumberBox("USA Flag Data", "Enter the Flag Height", Flag.HoistFlag)
    if Flag.Inquiry then
      if Flag.HoistFlag > 0 then
        Loops = false
      else
        DisplayMessageBox("Error: The Flag hight must be larger than '0.00'")
        Loops = true
      end -- if end
    else
      Loops = false
    end -- if end
  end -- while end

  if (Flag.Inquiry and (Flag.HoistFlag > 0)) then
    Flag.HoistUnion = 0.5385 * Flag.HoistFlag ;
    Flag.FlyFlag = 1.9 * Flag.HoistFlag ;
    Flag.FlyUnion = 0.76 * Flag.HoistFlag ;
    Flag.UnionStarCentersV = 0.054 * Flag.HoistFlag ;
    Flag.UnionStarCentersH = 0.063 * Flag.HoistFlag ;
    Flag.StarDia = 0.0616 * Flag.HoistFlag ;
    Flag.StarOutRadius = 0.5 * Flag.StarDia
    Flag.StarInRadius = Flag.StarDia * 0.190983
    Flag.Stripe = 0.0769 * Flag.HoistFlag ;
-- ======
    Flag.Gpt1 = Point2D(1, 1)
    Flag.Gpt2 = Polar2D(Flag.Gpt1,  0.0, Flag.FlyFlag)
    Flag.Gpt3 = Polar2D(Flag.Gpt2,  90.0, Flag.HoistFlag)
    Flag.Gpt4 = Polar2D(Flag.Gpt1,  90.0, Flag.HoistFlag)
    Flag.Gpt5 = Polar2D(Flag.Gpt4,   0.0, Flag.FlyUnion)
    Flag.Gpt6 = Polar2D(Flag.Gpt4,  270.0, Flag.HoistUnion)
    USA_AirForceFlag(job)
    DrawUnion(job)
    DrawStripes(job)
    DrawLogo(job)
    DrawStars(job)
  end
  return true

end  -- function end
-- ===================================================