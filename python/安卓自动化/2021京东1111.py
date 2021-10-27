import time

share_page_line_2 = (0.790, 0.572)
share_page_line_4 = (0.791, 0.756)
share_page_line_5 = (0.791, 0.846)


def click_then_back(pos: tuple, times: int):
    for i in range(times):
        d.click(*pos)
        time.sleep(20)
        d.press('back')
        time.sleep(5)


click_then_back(share_page_line_5, 10)


def click_sleep_back(d, x, y, t):
    d.click(x, y)
    time.sleep(t)
    d.press("back")


for i in range(5):
    time.sleep(10)
    d.click(0.835, 0.754)
    time.sleep(10)

    click_sleep_back(d, 0.160, 0.294, 2)
    click_sleep_back(d, 0.786, 0.329, 2)
    click_sleep_back(d, 0.288, 0.642, 2)
    click_sleep_back(d, 0.808, 0.685, 2)
    click_sleep_back(d, 0.293, 0.885, 2)

    d.press("back")

for i in range(25):
    d.click(0.791, 0.572)
    time.sleep(20)
    d.press('back')
    time.sleep(5)
