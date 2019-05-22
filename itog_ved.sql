if not exists (select * from sysobjects where id = object_id('tb_itog_ved2') and OBJECTPROPERTY(id, 'IsUserTable') = 1)
--if not exists (select * from sysobjects where id = object_id('tb_itog_ved3') and OBJECTPROPERTY(id, 'IsUserTable') = 1)


create table tb_itog_ved2
(id_user int NULL, key_f varchar(15) NULL, tab char(100) NULL, sirname char(100) NULL,
nachisl decimal(16,4) NULL, sp_schet decimal(16,4) NULL, proch_doh decimal(16,4) NULL, liter decimal(16,4) NULL, 
 dolg_pr decimal(16,4) NULL, proch_vipl decimal(16,4) NULL, podoh decimal(16,4) NULL, podoh_ch decimal(16,4) NULL, 
profvz decimal(16,4) NULL, profvz_ch decimal(16,4) NULL, vsego_uder decimal(16,4) NULL,
 v_bank decimal(16,4) NULL, dolg_rab decimal(16,4) NULL, vipl_ranee decimal(16,4) NULL, pos_mame decimal(16,4) NULL, 
PF_str decimal(16,4) NULL, fss decimal(16,4) NULL, foms decimal(16,4) NULL,  base_esn decimal(16,4) NULL, 
baze_travm decimal(16,4) NULL, travm decimal(16,4) NULL, esn decimal(16,4) NULL, nn int NULL)



GRANT SELECT, INSERT, UPDATE, DELETE ON tb_itog_ved2 TO AitUsers
--GRANT SELECT, INSERT, UPDATE, DELETE ON tb_itog_ved3 TO AitUsers
GO
--  drop proc itog_ved          drop table tb_itog_ved2    drop table tb_itog_ved3   drop view itogi

CREATE  PROCEDURE itog_ved @id_user int, @mm1 int, @mm2 int, @yy int, @kf varchar(15) 
AS

delete from tb_itog_ved2 where id_user = @id_user

insert into tb_itog_ved2 (id_user) select @id_user
update tb_itog_ved2 set nn=(select count(pers_id) from pbpers4user where header_key_f = @kf) 
--insert into tb_itog_ved2 (id_user, key_f)  select @id_user, pers_id from pbpers4user where header_key_f = @kf

--update tb_itog_ved2 set tab=(select tabel_n from const where pers_id=tb_itog_ved2.key_f) 
--update tb_itog_ved2 set sirname=(select rtrim(name)+' '+left(first_name,1)+'.'+left(sec_name,1) +'.' from const where pers_id=tb_itog_ved2.key_f)  

--начисления

UPDATE tb_itog_ved2 SET 
nachisl = (select isnull(sum(summa),0) FROM arhiv_ras
WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND arhiv_ras.code='500' AND ras_yy = @yy  AND arhiv_ras.ras_mm >= @mm1 AND arhiv_ras.ras_mm <=@mm2)

--nachisl = ((select sum(summa) FROM arhiv_ras WHERE pers_id=tb_itog_ved2.key_f  AND code='500' AND ras_yy = @yy   AND ras_mm >= @mm1 AND ras_mm <=@mm2) - 
--   (select sum(summa) FROM arhiv_ras WHERE pers_id=tb_itog_ved2.key_f  AND (code='058' OR code='080')  AND ras_yy = @yy   AND ras_mm >= @mm1 AND ras_mm <=@mm2))

UPDATE tb_itog_ved2 SET 
sp_schet = (select isnull(sum(summa),0) FROM arhiv_ras  WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND code='100' AND ras_yy = @yy  AND ras_mm >= @mm1 
AND ras_mm <=@mm2 ) 

UPDATE tb_itog_ved2 SET 
proch_doh = (select isnull(sum(summa),0) FROM arhiv_ras  WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND (code='058' OR code='080') AND ras_yy = @yy  
 AND ras_mm >= @mm1 AND ras_mm <=@mm2 ) 

UPDATE tb_itog_ved2 SET 
liter = (select isnull(sum(summa),0) FROM arhiv_ras  WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND code='117' AND ras_yy = @yy   AND ras_mm >= @mm1 
AND ras_mm <=@mm2 ) 

--удержания

UPDATE tb_itog_ved2 SET 
dolg_pr = (select isnull(sum(summa),0) FROM arhiv_ras   WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND code='799' AND ras_yy = @yy  AND ras_mm >= @mm1 
AND ras_mm <=@mm2 )

UPDATE tb_itog_ved2 SET 
proch_vipl = (select isnull(sum(summa),0) FROM arhiv_ras    WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND code='996' AND ras_yy = @yy  
AND ras_mm >= @mm1 AND ras_mm <=@mm2 ) 

UPDATE tb_itog_ved2 SET 
podoh = (select isnull(sum(summa),0) FROM arhiv_ras    WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND code='780' AND ras_yy = @yy 
 AND ras_mm >= @mm1 AND ras_mm <=@mm2 ) 

UPDATE tb_itog_ved2 SET 
podoh_ch = (select isnull(sum(summa),0) FROM arhiv_ras    WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND code='781' AND ras_yy = @yy   
AND ras_mm >= @mm1 AND ras_mm <=@mm2 ) 

UPDATE tb_itog_ved2 SET 
profvz = (select isnull(sum(summa),0) FROM arhiv_ras    WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND code='795' AND ras_yy = @yy   
AND ras_mm >= @mm1 AND ras_mm <=@mm2 ) 

UPDATE tb_itog_ved2 SET 
profvz_ch = (select isnull(sum(summa),0) FROM arhiv_ras    WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND code='796' AND ras_yy = @yy   
AND ras_mm >= @mm1 AND ras_mm <=@mm2 ) 

UPDATE tb_itog_ved2 SET 
vsego_uder = (select isnull(sum(summa),0) FROM arhiv_ras    WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND code='800' AND ras_yy = @yy   
AND ras_mm >= @mm1 AND ras_mm <=@mm2 ) 

----- перечисления

UPDATE tb_itog_ved2 SET 
v_bank = (select isnull(sum(summa),0) FROM arhiv_ras   WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  
    AND (code='701' OR code='502' OR code='503' OR code='504' OR code='521' OR code='522' OR code='526' OR code='527') 
  AND ras_yy = @yy  AND ras_mm >= @mm1 AND ras_mm <=@mm2  )                       ---code='999' это на руки

UPDATE tb_itog_ved2 SET 
dolg_rab = (select isnull(sum(summa),0) FROM arhiv_ras   WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND code='893' AND ras_yy = @yy   
AND ras_mm >= @mm1 AND ras_mm <=@mm2 ) 

UPDATE tb_itog_ved2 SET 
vipl_ranee = (select isnull(sum(summa),0) FROM arhiv_ras WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND code='997' AND ras_yy = @yy   
AND ras_mm >= @mm1 AND ras_mm <=@mm2 ) 

UPDATE tb_itog_ved2 SET 
pos_mame = (select isnull(sum(summa),0) FROM arhiv_ras    WHERE pers_id in (select pers_id from pbpers4user where header_key_f = @kf)  AND code='022' AND ras_yy = @yy   
AND ras_mm >= @mm1 AND ras_mm <=@mm2 ) 

------ страх взносы

---UPDATE tb_itog_ved2 SET PF_baz=(select sum(nalog) from arhiv_social where mm>=@mm1 and yy=@yy and code_nalog=1 and pers_id=key_f)
---UPDATE tb_itog_ved2 SET PF_nak=(select sum(nalog) from arhiv_social where mm>=@mm1 and yy=@yy and code_nalog=7 and pers_id=key_f)
---UPDATE tb_itog_ved2 SET TOMS=(select sum(nalog) from arhiv_social where mm>=@mm1 and yy=@yy and code_nalog=4 and pers_id=key_f)


UPDATE tb_itog_ved2 SET  PF_str=(select isnull(sum(nalog),0) from arhiv_social where  mm >= @mm1 AND mm <=@mm2 
and yy=@yy and code_nalog=6 and pers_id in (select pers_id from pbpers4user where header_key_f = @kf) ) 

UPDATE tb_itog_ved2 SET  fss=(select isnull(sum(nalog),0) from arhiv_social where  mm >= @mm1 AND mm <=@mm2 and yy=@yy 
and code_nalog=2 and pers_id in (select pers_id from pbpers4user where header_key_f = @kf) ) 

UPDATE tb_itog_ved2 SET  foms=(select isnull(sum(nalog),0) from arhiv_social where  mm >= @mm1 AND mm <=@mm2 and yy=@yy 
and code_nalog=3 and pers_id in (select pers_id from pbpers4user where header_key_f = @kf) ) 

UPDATE tb_itog_ved2 SET  travm=(select isnull(sum(nalog),0) from arhiv_travm where  mm >= @mm1 AND mm <=@mm2 and yy=@yy 
and pers_id in (select pers_id from pbpers4user where header_key_f = @kf) ) 

UPDATE tb_itog_ved2 SET  base_esn = (select isnull(sum(summa_oblag),0) from arhiv_social where   mm >= @mm1 
AND mm <=@mm2 and yy=@yy and code_nalog=6 and pers_id in (select pers_id from pbpers4user where header_key_f = @kf) )             ---and nalog<>0 ----------код налога????

UPDATE tb_itog_ved2 SET  baze_travm = (select isnull(sum(summa_oblag),0) from arhiv_travm where mm >= @mm1 AND mm <=@mm2 
and yy=@yy and pers_id in (select pers_id from pbpers4user where header_key_f = @kf) )

GO
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_itog_ved2 TO AitUsers

---- заполнение представления itogi суммами из tb_itog_ved2 

GO


/*if not exists (select * from sysobjects where id = object_id('itogi') and OBJECTPROPERTY(id, 'IsUserTable') = 1)
--GRANT SELECT, INSERT, UPDATE, DELETE ON itogi TO AitUsers
--GO
--CREATE VIEW itogi AS SELECT nachisl, sp_schet   FROM tb_itog_ved2 

CREATE VIEW itogi AS SELECT 
           nachisl=sum(nachisl), sp_schet=sum(sp_schet), proch_doh=sum(proch_doh), liter=sum(liter), dolg_pr=sum(dolg_pr), 
           proch_vipl=sum(proch_vipl), podoh=sum(podoh), podoh_ch=sum(podoh_ch), profvz=sum(profvz), profvz_ch=sum(profvz_ch), 
           vsego_uder=sum(vsego_uder), v_bank=sum(v_bank), dolg_rab=sum(dolg_rab), vipl_ranee=sum(vipl_ranee), pos_mame=sum(pos_mame), 
           PF_str=sum(PF_str), fss=sum(fss), foms=sum(foms), base_esn=sum(base_esn), baze_travm=sum(baze_travm), travm=sum(travm), 
           esn=sum(esn), nn=count(tab), id_user=sum(id_user)/count(tab)   FROM tb_itog_ved2 
            
 
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON itogi TO AitUsers
GO

------------заполнение суммарной таблицы tb_itog_ved3

 

if not exists (select * from sysobjects where id = object_id('tb_itog_ved3') and OBJECTPROPERTY(id, 'IsUserTable') = 1)


create table tb_itog_ved3                
(id_user int NULL, key_f varchar(15) NULL, 
nachisl decimal(16,4) NULL, sp_schet decimal(16,4) NULL, proch_doh decimal(16,4) NULL, liter decimal(16,4) NULL, 
dolg_pr decimal(16,4) NULL, proch_vipl decimal(16,4) NULL, podoh decimal(16,4) NULL, podoh_ch decimal(16,4) NULL, 
profvz decimal(16,4) NULL, profvz_ch decimal(16,4) NULL, vsego_uder decimal(16,4) NULL,
v_bank decimal(16,4) NULL, dolg_rab decimal(16,4) NULL, vipl_ranee decimal(16,4) NULL, pos_mame decimal(16,4) NULL, 
PF_str decimal(16,4) NULL, fss decimal(16,4) NULL, foms decimal(16,4) NULL,  base_esn decimal(16,4) NULL, 
baze_travm decimal(16,4) NULL, travm decimal(16,4) NULL, esn decimal(16,4) NULL, nn int NULL)

GRANT SELECT, INSERT, UPDATE, DELETE ON tb_itog_ved3 TO AitUsers
GO

--TRUNCATE TABLE tb_itog_ved3

delete from tb_itog_ved3 

INSERT INTO tb_itog_ved3 
      (nachisl, sp_schet, proch_doh, liter, dolg_pr, proch_vipl, podoh, podoh_ch, profvz, 
     profvz_ch, vsego_uder, v_bank, dolg_rab, vipl_ranee, pos_mame, PF_str, fss, foms, 
  base_esn, baze_travm, travm, esn, nn, id_user) 
 -- SELECT
--  isnull(sum(nachisl),0), isnull(sum(sp_schet),0), isnull(sum(proch_doh),0), isnull(sum(liter),0), isnull(sum(dolg_pr),0), 
--           isnull(sum(proch_vipl),0), isnull(sum(podoh),0), isnull(sum(podoh_ch),0), isnull(sum(profvz),0), isnull(sum(profvz_ch),0), 
--           isnull(sum(vsego_uder),0), isnull(sum(v_bank),0), isnull(sum(dolg_rab),0), isnull(sum(vipl_ranee),0), isnull(sum(pos_mame),0), 
--           isnull(sum(PF_str),0), isnull(sum(fss),0), isnull(sum(foms),0), isnull(sum(base_esn),0), isnull(sum(baze_travm),0), isnull(sum(travm),0), 
--           isnull(sum(esn),0), isnull(count(tab),0), isnull(max(id_user),0)   FROM tb_itog_ved2 
--SELECT nachisl, sp_schet, proch_doh, liter, dolg_pr, proch_vipl, podoh, podoh_ch, profvz, profvz_ch, vsego_uder, v_bank, 
--       dolg_rab, vipl_ranee, pos_mame, PF_str, fss, foms, base_esn, baze_travm, travm, esn, nn, id_user
--FROM  itogi 

     
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON tb_itog_ved3 TO AitUsers

GO
*/
GRANT EXECUTE ON itog_ved TO AitUsers

GO


