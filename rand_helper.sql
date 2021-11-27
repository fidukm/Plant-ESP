CREATE DEFINER=`root`@`localhost` FUNCTION `rand_helper`(minval float, maxval float) RETURNS float
    NO SQL
    DETERMINISTIC
BEGIN
  RETURN (minval+RAND()*(maxval-minval));
END