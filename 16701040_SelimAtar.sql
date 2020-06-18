USE [Kutuphane_Ornek]
GO

/****** Object:  StoredProcedure [dbo].[kitapkontrol2]    Script Date: 6/16/2020 8:18:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/*	Kitaplar tablosunda girilen kitapın aynısı varsa diğer girilen parametreleri(kitaplar tablosundan;
	yayıntarihi, sayfa sayısı, kitap adı, yazarlar tablosundan; yazar adı ) 
	güncelleyen yoksa ekleyen Stored Procedure */

CREATE PROCEDURE [dbo].[kitapkontrol2](@yayınTarih smalldatetime, @sayfaSayı smallint, @kitap varchar(50), @yazar varchar(50))
AS
BEGIN
	declare @kitapId int
	set @kitapId=null

	SET NOCOUNT ON;
	select @kitapId = KitapId from Kitaplar where KitapAdi = @kitap

	if ( @kitapId is not null )
	begin
	update Kitaplar set YayınTarihi = @yayınTarih where KitapId = @kitapId
	update Kitaplar set Ssayisi = @sayfaSayı where KitapId = @kitapId
	select * from Kitaplar where KitapId = @kitapId
	select YazarAdSoyad from Yazarlar where KitapId = @kitapId
	update Yazarlar set YazarAdSoyad = @yazar where KitapId = @kitapId
	end

	else
	begin
	insert into Kitaplar(KitapAdi,YayınTarihi,Ssayisi) values (@kitap,@yayınTarih,@sayfaSayı)
	select @kitapId = KitapId from Kitaplar where KitapAdi = @kitap
	insert into Yazarlar(KitapId,YazarAdSoyad) values (@kitapId,@yazar)
	end
	
END
GO

