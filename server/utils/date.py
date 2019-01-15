import datetime
import calendar
import time

# %a	本地（locale）简化星期名称
# %A	本地完整星期名称
# %b	本地简化月份名称
# %B	本地完整月份名称
# %c	本地相应的日期和时间表示
# %d	一个月中的第几天（01 - 31）
# %H	一天中的第几个小时（24小时制，00 - 23）
# %I	第几个小时（12小时制，01 - 12）
# %j	一年中的第几天（001 - 366）
# %m	月份（01 - 12）
# %M	分钟数（00 - 59）
# %p	本地am或者pm的相应符
# %S	秒（01 - 61）
# %U	一年中的星期数。（00 - 53星期天是一个星期的开始。）第一个星期天之前的所有天数都放在第0周。
# %w	一个星期中的第几天（0 - 6，0是星期天）
# %W	和%U基本相同，不同的是%W以星期一为一个星期的开始。
# %x	本地相应日期
# %X	本地相应时间
# %y	去掉世纪的年份（00 - 99）
# %Y	完整的年份
# %Z	时区的名字（如果不存在为空字符）
# %%	‘%’字符


def get_season():
    """
    获取当前赛季的索引和距离下一个赛季的秒数
    """
    week = int(datetime.datetime.now().strftime("%U"))
    return str(int(week / 2))
    # 获取下个赛季的周一


def get_next_season_time():
    """
    获取下一个赛季的时间（2017/06/12 00：00：00）
    :return: 下一个赛季的时间（2017/06/12 00：00：00）
    """
    c_season = get_season()
    next_season_first_day = datetime.datetime.today().replace(hour=0, minute=0, second=0,microsecond=0)
    one_day = datetime.timedelta(days=1)
    is_next_season = False
    while next_season_first_day.weekday() != calendar.MONDAY or (not is_next_season):
        next_season_first_day += one_day
        next_season_week = int(int(next_season_first_day.strftime("%U")) / 2)
        is_next_season = next_season_week == c_season + 1
    return time_stamp(next_season_first_day)


def time_stamp(time_to_convert=datetime.datetime.now()):
    return time_to_convert.strftime("%Y/%m/%d %H:%M:%S")


if __name__ == '__main__':
    current_season, next_season_time = get_season(), get_next_season_time()
    print(current_season, next_season_time)


