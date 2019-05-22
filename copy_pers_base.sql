
--select * from const where n_otd<>'9999' and pers_id=pers_id_main and pers_id in ('a274','s426','w205','w200') 
--order by name  
--where pers_id in (select pers_id from #tmp_const) 

--select * from family_pers where pers_id in (select pers_id from #tmp_const)
--select * from xcheck order by brief_name

USE shpag
drop table #tmp_const
drop table #tmp_alim
drop table #tmp_sp_ispolnit_list
drop table #tmp_children
drop table #tmp_sp_strah
drop table #tmp_sp_ssud
drop table #tmp_perech
drop table #tmp_nall
drop table #tmp_constik
drop table #tmp_stag_pers
drop table #tmp_family_pers

select * into #tmp_const from const where n_otd<>'9999' and pers_id=pers_id_main and pers_id in ('a274','s426','w205','w200')
--n_otd='u9' 
select * into #tmp_alim from alim where pers_id in (select pers_id from #tmp_const)
select * into #tmp_sp_ispolnit_list from sp_ispolnit_list where pers_id in (select pers_id from #tmp_const)
select * into #tmp_children from children where pers_id in (select pers_id from #tmp_const)
select * into #tmp_sp_strah from sp_strah  where pers_id in (select pers_id from #tmp_const)
select * into #tmp_sp_ssud  from sp_ssud   where pers_id in (select pers_id from #tmp_const)
select * into #tmp_perech   from perech    where pers_id in (select pers_id from #tmp_const)
select * into #tmp_nall   from nall    where pers_id in (select pers_id from #tmp_const)
select * into #tmp_constik   from constik     where pers_id in (select pers_id from #tmp_const)
select * into #tmp_stag_pers   from stag_pers   where pers_id in (select pers_id from #tmp_const)
select * into #tmp_family_pers   from family_pers   where pers_id in (select pers_id from #tmp_const)



USE dvias
declare @v_pers_id varchar(15),@new_p_id varchar(15), @result int
DECLARE Cur1 CURSOR FOR  
SELECT pers_id from #tmp_const   
OPEN Cur1  
FETCH NEXT FROM Cur1 into @v_pers_id  
WHILE @@FETCH_STATUS = 0  
   BEGIN
		exec @result = sp_copy_pers_base 'r28',@v_pers_id,'r','', @new_p_id OUTPUT 
      FETCH NEXT FROM Cur1 into @v_pers_id   
   END  
CLOSE Cur1  
DEALLOCATE Cur1  
GO  

if object_id('dbo.sp_copy_pers_base') is not null
begin
   drop procedure dbo.sp_copy_pers_base
end
go


CREATE PROCEDURE [dbo].[sp_copy_pers_base] 
	@n_otd varchar(15),
	@pers_id varchar(15),
	@prefix varchar(4),
	@tab_n varchar(32),
	@new_p_id varchar(15) OUTPUT
  AS BEGIN 
DECLARE 
	@result int,
	@is_alim char(1),
	@is_ispol char(1),
	@is_igd tinyint,
	@is_strah char(1),
	@is_ssud char(1),
	@is_bank char(1),
	@name varchar(40), @first_name varchar(40), @sec_name varchar(40), 
	@dolsn varchar(32), @oklad decimal(16,4), @nall smallInt, 
	@code_pens char(1), @code_podn char(1), @code_prof char(1), @vid char(1), 
	@pass_seria varchar(15), @pass_num varchar(15), @pass_kem varchar(70), 
	@pass_date datetime, @pass_propusk varchar(20), @adress varchar(200), 
	@date_r datetime, @date_stage datetime, @date_post datetime, @date_out datetime, 
	@brv varchar(15), @zatr varchar(8), @category varchar(3), @status char(1), 
	@sprm1k varchar(50), @sprm2k varchar(50), @sprm3k varchar(50), @sprm4k varchar(50), 
	@sprm5k varchar(50), @sprm6k varchar(50), @sprm7k varchar(50), @sprm8k varchar(50), 
	@konst1 money, @konst2 money, @konst3 money, @konst4 money, 
	@konst5 money, @konst6 money, @konst7 money, @konst8 money, 
	@metka_n tinyint, @sever money, @rayon money, @date_sever datetime, @n_scala tinyint, 
	@n_scala_soc tinyint, @pass_kod_podr varchar(10),
	@sex char(1), @pf_strah_num char(15), @fl_ed varchar(10), @fl_2adress char(1), @fl_army char(1),
	@pers_inn varchar(40), @sum_stage decimal(16,4), @category_pf char(10),  @fam_status char(1) 

    BEGIN TRAN
    SELECT 'Мы вошли в процедуру sp_copy_person_base', @n_otd
    select @new_p_id = 'copy_sotr'
    exec @result = create_person_sp @n_otd, @prefix, @tab_n, @new_p_id OUTPUT

    if @@error <> 0 OR @result < 0
    BEGIN
	ROLLBACK TRAN
	raiserror( 'Ошибка создания копии сотрудника', 16, 1)
	return -1
    END

--  INSERT INTO const  (pers_id,    tabel_n,      n_otd,  first_name, sec_name, dolsn, oklad,nall, code_pens, code_prof, vid, pass_seria, pass_num, pass_kem, pass_date, pass_propusk, adress, date_r, date_stage, date_post, date_out, brv, zatr, category, code_podn, child, igdiven, status, alim, ispol, bank, strah, ssud, sprm1k, sprm2k, sprm3k, sprm4k, sprm5k, sprm6k, sprm7k, sprm8k, konst1, konst2, konst3, konst4, konst5, konst6, konst7, konst8, metka_n )  
--    SELECT           :key_f , :DOUBLE_TABN , name,  :n_otd, first_name, sec_name, dolsn, oklad,nall, code_pens, code_prof, vid, pass_seria, pass_num, pass_kem, pass_date, pass_propusk, adress, date_r, date_stage, date_post, date_out, brv, zatr, category, code_podn, child, igdiven, status, alim, ispol, bank, strah, ssud, sprm1k, sprm2k, sprm3k, sprm4k, sprm5k, sprm6k, sprm7k, sprm8k, konst1, konst2, konst3, konst4, konst5, konst6, konst7, konst8, metka_n
--    FROM const     WHERE pers_id = :person_id 



    SELECT @is_alim = alim, @is_ispol = ispol, @is_igd = igdiven, @is_strah = strah,
     @is_ssud = ssud, @is_bank = bank, @name = name,  @first_name = first_name,  
     @sec_name = sec_name,  @dolsn = dolsn,  @oklad = oklad,  @nall = nall,  
     @code_podn = code_podn,  @code_pens = code_pens,  @code_prof = code_prof,  
     @vid = vid,  @pass_seria = pass_seria,  @pass_num = pass_num,  @pass_kem = pass_kem,
     @pass_date = pass_date,  @pass_propusk = pass_propusk,  @adress = adress,  @date_r = date_r,  
     @date_stage = date_stage,  @date_post = date_post,  @date_out = date_out,  @brv = brv,
     @zatr = zatr,  @category = category,  @status = status,  @sprm1k = sprm1k,  
     @sprm2k = sprm2k,  @sprm3k = sprm3k,  @sprm4k = sprm4k,  @sprm5k = sprm5k,  
     @sprm6k = sprm6k,  @sprm7k = sprm7k,  @sprm8k = sprm8k,  @konst1 = konst1,
     @konst2 = konst2,  @konst3 = konst3,  @konst4 = konst4,  @konst5 = konst5,
     @konst6 = konst6,  @konst7 = konst7,  @konst8 = konst8,  @metka_n = metka_n,  
     @sever = sever,  @rayon = rayon,  @date_sever = date_sever,  @n_scala = n_scala,
     @n_scala_soc = n_scala_soc, @pass_kod_podr =pass_kod_podr, @sex=sex,
     @pf_strah_num=pf_strah_num, @fl_ed=fl_ed, @fl_2adress=fl_2adress,@fl_army=fl_army,
     @sum_stage=sum_stage,@pers_inn=pers_inn,@category_pf=category_pf,
     @fam_status=fam_status
    FROM #tmp_const     WHERE pers_id = @pers_id 

    if @@error <> 0
    BEGIN
	ROLLBACK TRAN
	RaisError( 'Ошибка чтения данных из const', 16, 1)
	return -2
    END

    SELECT 'Debug: SELECT from const ', @name, @first_name, @sec_name, ' Новый pers_id', @new_p_id

    UPDATE const SET 
    alim = @is_alim, ispol = @is_ispol, igdiven = @is_igd, strah = @is_strah, 
    ssud = @is_ssud, bank = @is_bank, name = @name,  first_name = @first_name, 
    sec_name = @sec_name, dolsn = @dolsn, oklad = @oklad, nall = @nall,  
    code_podn= @code_podn, code_pens = @code_pens, code_prof = @code_prof,
    vid = @vid, pass_seria = @pass_seria, pass_num = @pass_num, pass_kem = @pass_kem,
    pass_date = @pass_date, pass_propusk = @pass_propusk, adress = @adress,
    date_r = @date_r, date_stage = @date_stage, date_post = @date_post, 
    date_out = @date_out, brv = @brv, zatr = @zatr,  category = @category, 
    status = @status, sprm1k = @sprm1k, sprm2k = @sprm2k, sprm3k = @sprm3k, 
    sprm4k = @sprm4k,  sprm5k = @sprm5k, sprm6k = @sprm6k,  sprm7k = @sprm7k, 
    sprm8k = @sprm8k, konst1 = @konst1, konst2 = @konst2, konst3 = @konst3,
    konst4 = @konst4, konst5 = @konst5, konst6 = @konst6,  konst7 = @konst7, 
    konst8 = @konst8, metka_n = @metka_n, sever = @sever, rayon = @rayon,
    date_sever = @date_sever, n_scala = @n_scala,
     n_scala_soc = @n_scala_soc, pass_kod_podr =@pass_kod_podr, sex=@sex,
     pf_strah_num=@pf_strah_num, fl_ed=@fl_ed, fl_2adress=@fl_2adress,fl_army=@fl_army,
     sum_stage=@sum_stage,pers_inn=@pers_inn,category_pf=@category_pf,
     fam_status=@fam_status
    WHERE pers_id = @new_p_id
    if @@error <> 0 
    BEGIN
	ROLLBACK TRAN
	RaisError( 'Ошибка обновления данных в const для копии сотрудника', 16, 1)
	return -3
    END
    COMMIT TRAN
    BEGIN TRAN
    SELECT 'Debug: UPDATE const ', @name, @first_name, @sec_name, @is_alim, @is_ispol, @is_igd, @is_strah, @is_ssud, @is_bank, @nall
    If @is_alim = NULL SELECT @is_alim =' '
    If @is_ispol = NULL SELECT @is_ispol =' '
    If @is_igd = NULL SELECT @is_igd = 0
    If @is_strah = NULL SELECT @is_strah = ' '
    If @is_ssud = NULL SELECT @is_ssud =' '
    If @is_bank = NULL SELECT @is_bank =' '
    If @nall = NULL SELECT @nall = 0

  
    If @is_alim = '1' 
    INSERT INTO alim   ( key_f,  pers_id,  priznak,   n_il,   adress,   bank,   fami,   imya,   otchesvto,   summa,   pochta,   filial,   nomer_schet, rayon_kof_child, prc_pochta, vid_pochta_sbor, bank_sbor )  
	 SELECT RTrim(key_f) + @new_p_id, @new_p_id,  priznak,   n_il,   adress,   bank,   fami,   imya,   otchesvto,   summa,   pochta,   filial,   nomer_schet, rayon_kof_child, prc_pochta, vid_pochta_sbor, bank_sbor
	FROM #tmp_alim  WHERE pers_id = @pers_id 
    if @@ERROR <> 0
    BEGIN
	ROLLBACK TRAN
	RaisError( 'Ошибка обновления данных в alim для копии сотрудника', 16, 1)
	return -11
    END
    If @is_ispol = '1' 
	  INSERT INTO sp_ispolnit_list ( key_f,  pers_id,    n_isp_list,   bank,   filial,    nomer_schet,     summa, priznak, take_after_nalog, bank_sbor )  
			  SELECT RTrim(key_f) +@new_p_id, @new_p_id ,   n_isp_list,   bank,   filial,    nomer_schet,     summa, priznak, take_after_nalog, bank_sbor 
	FROM #tmp_sp_ispolnit_list       WHERE pers_id = @pers_id 
    if @@ERROR <> 0
    BEGIN
	ROLLBACK TRAN
	RaisError( 'Ошибка обновления данных в sp_ispolnit_list для копии сотрудника', 16, 1)
	return -12
    END
    If @is_igd >  0  
	  INSERT INTO children  ( key_f,    pers_id,    name,    born )  
			SELECT RTrim(key_f) +@new_p_id, @new_p_id ,name,    born 
			From #tmp_children       WHERE pers_id = @pers_id 
    if @@ERROR <> 0
    BEGIN
	ROLLBACK TRAN
	RaisError( 'Ошибка обновления данных в children для копии сотрудника', 16, 1)
	return -13
    END
    If @is_strah = '1' 
	  INSERT INTO sp_strah ( key_f,   pers_id, number_doc, bank, filial, nomer_schet, summa, bank_sbor )
		 SELECT   RTrim(key_f) +@new_p_id, @new_p_id, number_doc, bank, filial, nomer_schet, summa, bank_sbor 
		FROM #tmp_sp_strah       WHERE pers_id = @pers_id 
    if @@ERROR <> 0
    BEGIN
	ROLLBACK TRAN
	RaisError( 'Ошибка обновления данных в sp_strah для копии сотрудника', 16, 1)
	return -14
    END
    If @is_ssud = '1' 
  	INSERT INTO sp_ssud   ( key_f,  pers_id,  summa,  ostatok )
			SELECT RTrim(key_f) +@new_p_id, @new_p_id ,  summa,  ostatok 
			From #tmp_sp_ssud       WHERE pers_id = @pers_id 

    if @@ERROR <> 0
    BEGIN
	ROLLBACK TRAN
	RaisError( 'Ошибка обновления данных в ssud для копии сотрудника', 16, 1)
	return -15
    END
    If @is_bank = '1' 
        INSERT INTO perech ( key_f,  pers_id,  number,  bank,  filial,  number_schet,  summa,  priznak, komu, bank_sbor )
	       SELECT RTrim(key_f) +@new_p_id, @new_p_id, number,  bank,  filial,  number_schet,  summa,  priznak, komu, bank_sbor 
		From #tmp_perech       WHERE pers_id = @pers_id 
    if @@ERROR <> 0
    BEGIN
	ROLLBACK TRAN
	RaisError( 'Ошибка обновления данных в perech для копии сотрудника', 16, 1)
	return -16
    END
    INSERT INTO stag_pers ( key_f,  pers_id,  tip,  comment,  date_begin,  date_end,  flag,  fl_otrasl, organization )
	       SELECT RTrim(key_f) +@new_p_id, @new_p_id, tip,  comment,  date_begin,  date_end,  flag,  fl_otrasl, organization
		From #tmp_stag_pers       WHERE pers_id = @pers_id 
    if @@ERROR <> 0
    BEGIN
	ROLLBACK TRAN
	RaisError( 'Ошибка обновления данных в stag_pers для копии сотрудника', 16, 1)
	return -17
	END
	INSERT INTO family_pers ( key_f,  pers_id,  name1,  rodstvo,  flag,  date_r )
	       SELECT RTrim(key_f) +@new_p_id, @new_p_id, name1,  rodstvo,  flag,  date_r
		From #tmp_family_pers       WHERE pers_id = @pers_id 
    if @@ERROR <> 0
    BEGIN
	ROLLBACK TRAN
	RaisError( 'Ошибка обновления данных в family_pers для копии сотрудника', 16, 1)
	return -18
	END
    If @nall > 0 
    begin
	SELECT 'DEBUG: nall, NEW key_f', RTRIM(key_f) + @new_p_id
	FROM nall WHERE pers_id = @pers_id 
	
        INSERT INTO nall ( key_f,  pers_id,  vid_lgots,  koef,  summa,  if_dohod,  d_begin,  d_end )
	       SELECT RTrim(key_f) + @new_p_id, @new_p_id, vid_lgots,  koef,  summa,  if_dohod,  d_begin,  d_end
		FROM #tmp_nall       WHERE pers_id = @pers_id 
    end
    if @@ERROR <> 0
      BEGIN
	ROLLBACK TRAN
	RaisError( 'Ошибка обновления данных в nall для копии сотрудника', 16, 1)
	return -19
      END
    DELETE FROM constik WHERE pers_id = @new_p_id
    INSERT INTO constik ( pers_id, name_komy, name_kogo, first_name_komy, first_name_kogo, sec_name_komy, sec_name_kogo, strana, oblast, rayon_r, gorod, old_work, army_grp, army_cat, army_sost, army_zv, army_vus, army_ready, army_rvk, adress_alt, post_ind1, post_ind2, army_doc, d1_not_army, d2_not_army, code_country, code_region, rayon, short_name_rayon, town, short_name_town, nasel_punct, short_name_nasel_punct, street, short_name_street, house, corpus, flat, no_army_cause, drive_vid, drive_num, drive_doc_num, drive_doc_cat, drive_doc_date,name_otkogo,first_name_otkogo,sec_name_otkogo,name_kem,first_name_kem,sec_name_kem,date_reg_mg,adress_pass,tk_date,tk_date_in,tk_date_out,tk_serianum,post_ind3,sp_house,sp_house_alt,sp_house_pass,code_reg_pass,rayon_pass,short_rayon_pass,town_pass,short_town_pass,nasel_p_pass,short_nasel_p_pass,street_pass,short_street_pass,house_pass,flat_pass,army_doc_date,army_bron,army_bron_num,army_bron_ser )
	       SELECT @new_p_id, name_komy, name_kogo, first_name_komy, first_name_kogo, sec_name_komy, sec_name_kogo, strana, oblast, rayon_r, gorod, old_work, army_grp, army_cat, army_sost, army_zv, army_vus, army_ready, army_rvk, adress_alt, post_ind1, post_ind2, army_doc, d1_not_army, d2_not_army, code_country, code_region, rayon, short_name_rayon, town, short_name_town, nasel_punct, short_name_nasel_punct, street, short_name_street, house, corpus, flat, no_army_cause, drive_vid, drive_num, drive_doc_num, drive_doc_cat, drive_doc_date,name_otkogo,first_name_otkogo,sec_name_otkogo,name_kem,first_name_kem,sec_name_kem,date_reg_mg,adress_pass,tk_date,tk_date_in,tk_date_out,tk_serianum,post_ind3,sp_house,sp_house_alt,sp_house_pass,code_reg_pass,rayon_pass,short_rayon_pass,town_pass,short_town_pass,nasel_p_pass,short_nasel_p_pass,street_pass,short_street_pass,house_pass,flat_pass,army_doc_date,army_bron,army_bron_num,army_bron_ser 
	FROM #tmp_constik WHERE pers_id = @pers_id
    if @@ERROR <> 0
      BEGIN
	ROLLBACK TRAN
	RaisError( 'Ошибка обновления данных в constik для копии сотрудника', 16, 1)
	return -20
      END
          
    COMMIT TRAN
    return 0
  end

  